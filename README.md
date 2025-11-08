# Installation
For UTM on MacOS, use the instructions over at [hosts/vm/README.md](hosts/vm/README.md).

## After install

You should now have a working NixOS installation with LUKS encryption.
When you boot you are asked to unlock the disk, and once you enter the password you chose you ought
to have booted into the new system.

### Setting your user's password
Assuming you are logged in as root:

```bash
passwd mull
```

Then log out (`exit`) and log in as your user.

# Using the repo
Sweet, now we can clone this repo and use it to set up the system.

```bash
mkdir -p ~/dev/
cd ~/dev/
git clone https://github.com/mull/nix.git
cd nix
```

By default we have our nix config living in /etc/nixos/.
We're going to point that folder to our local clone of the repo instead.

```bash
sudo mv /etc/nixos /etc/nixos.backup
sudo ln -s ~/dev/nix /etc/nixos
```

## Selecting a host
Sweet, now we can apply the config and reboot system. First, we need to select a host. Our repo contains two hosts in the hosts folder:
- hosts/vm made for UTM on MacOS
- hosts/framework made for the frame.work laptop

Whenever a command shows {host} you'll need to replace that with the name of your host (without brackets.)

## Hardware Configuration
The hardware configuration is handled automatically! The repo contains a wrapper file that imports your machine-specific hardware config from `/etc/nixos.backup/hardware-configuration.nix` (which we created earlier when backing up the original `/etc/nixos` directory).

This approach keeps your git repo clean while allowing each machine to have its own filesystem UUIDs and hardware settings.

## Applying the config
Now that the hardware configuration is in place, we can build and apply our configuration.

We want NixOS to build and install whatever it needs. However, at this stage we do NOT want to immediately switch to the new system, since we're swapping our system level stuff.

That would get NixOS stuck (it seems), so rather than use `switch` we will use `boot`, which will build the new system and make it the next default boot option, but not switch to it before we reboot.

```bash
# run this from ~/dev/nix/
sudo nixos-rebuild boot --impure --flake .#{host}
```

After a successful build, reboot your system:

```bash
sudo reboot
```

Should it fail to start, you can always reboot and use the second boot option to get back to the old system.



