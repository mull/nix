# Fresh install

I use a minimal NixOS installation with no desktop environment.
Common package such as git are not available by default, and to
make use of this repo we'll have to install it.

However, we can use `nix-shell` to get a shell with the necessary packages
without actually adding them to the system permanently!

```bash
nix-shell -p git
```

Sweet, now we can clone this repo nd use it to set up the syetem.

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
**Important!** The hardware configuration is machine-specific and not included in this repo. You need to copy the auto-generated hardware configuration from your fresh NixOS install:

```bash
# Copy your machine-specific hardware config to the appropriate host directory
# Replace {host} with your actual host name (e.g., vm or framework)
cp /etc/nixos.backup/hardware-configuration.nix ~/dev/nix/hosts/{host}/hardware-configuration.nix
```

This file contains your system's specific filesystem UUIDs and hardware settings.

## Applying the config
Now that the hardware configuration is in place, we can build and apply our configuration.

We want NixOS to build and install whatever it needs. However, at this stage we do NOT want to immediately switch to the new system, since we're swapping our system level stuff.

That would get NixOS stuck (it seems), so rather than use `switch` we will use `boot`, which will build the new system and make it the next default boot option, but not switch to it before we reboot.

```bash
# run this from ~/dev/nix/
sudo nixos-rebuild boot --flake .#{host}
```

After a successful build, reboot your system:

```bash
sudo reboot
```

Should it fail to start, you can always reboot and use the second boot option to get back to the old system.



