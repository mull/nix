# Installation
These instructions are for UTM on MacOS.

The ISO download can be found at [https://nixos.org/download.html](https://nixos.org/download.html). These instructions assume you picked the minimal installer without a GUI. (The GUI installer has no support for LUKS encryption, so why use it at all.)

Set up the USB "drive" with UTM, and a virtio disk of at least 10GB size.

Start by becoming root, which is passwordless in the NixOS installer:
```bash
sudo -i
```

## Installing an editor
nix-shell is available in the installer, you can use it to install your favorite editor.
```bash
nix-shell -p helix
```

## Hard disk encryption and filesystem setup
Once you're in the installer we can set up hard disk encryption. First, create a GPT label and two partitions: one for the EFI System Partition (ESP), which is required for booting in UEFI mode, and one for the root filesystem. We won't be using a swap drive for this setup since we're just trying this through UTM anyhow. 

```bash
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart ESP fat32 1MiB 513MiB
parted /dev/vda -- set 1 esp on
parted /dev/vda -- mkpart primary ext4 513MiB 100%
```

This leaves us with:

```
/dev/vda1  → EFI System Partition
/dev/vda2  → to become LUKS container
```

Next we set up LUKS encryption on /dev/vda2 and then open it. Follow instructions on screen (notice the uppercase YES required.)

```bash
cryptsetup luksFormat /dev/vda2
cryptsetup luksOpen /dev/vda2 cryptroot
```

Next we create fileystems

```bash
mkfs.fat -F 32 /dev/vda1
mkfs.ext4 /dev/mapper/cryptroot
```

## Mounting and generating the NixOS configuration for first boot
```bash
mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount /dev/vda1 /mnt/boot
```

Use NixOS `nixos-generate-config` to generate a configuration for the first boot.

```bash
nixos-generate-config --root /mnt
```

This will create files called `hardware-configuration.nix` and `configuration.nix` in the `/mnt/etc/nixos` directory.  

### `hardware-configuration.nix`
`hardware-configuration.nix` is unfortunately not prepped correctly for LUKS, so we have to make a few changes. The UUIDs for the cryproot entry is already correct, so we don't need to worry about that one. The `filesystems."/"` entry needs changing though, as it should point to the cryptroot device mapper.

The entry should look like this:
```nix
fileSystems."/" = {
  device = "/dev/mapper/cryptroot";
  fsType = "ext4";
};
```

For reference, the other two entries will look roughly ike this:

```nix
boot.initrd.luks.devices."cryptroot" = {
  device = "/dev/disk/by-partuuid/<UUID-of-vda2>";
};

fileSystems."/boot" = {
  device = "/dev/vda1";
  fsType = "vfat";
};
```

### `configuration.nix`
There is [an issue](https://github.com/utmapp/UTM/issues/3555) with UTM and LUKS unlocking, so we need to add a kernel parameter to the boot config. Otherwise we'll get a black screen.
Anywhere in `configuration.nix` add the following:

```nix
boot.kernelParams = [ "console=tty1" ];
```

### Creating a user
We need to create a user account. There is already a user entry in `configuration.nix`, so just edit it to have the `mull` username.


```nix
users.users.mull = {
  isNormalUser = true;
  description = "Emil";
  extraGroups = ["networkmanager" "wheel"];
};
```
## Installing NixOS
Now we can use NixOS to install itself to the new disk!

```bash
nixos-install
```

You will be prompted to enter a root password. Set one and remember it! It can be changed later, and is not tied to hard disk encryption.

When you reboot you will be asked to unlock the disk. Entering the password correctly you'll end up at a login prompt. Log in as root for now. Then head back to the main [README.md](../README.md) for the next steps.