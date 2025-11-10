Please check out the [README for the UTM VM first](../vm/README.md).
This README merely adapts that one and has few extras.

13" frame.work laptop with 32GB ram and 1TB SSD.

We'll use a 34GB swap partition to allow for complete hibernation (i.e. write the entire RAM to disk.)
We'll split / and /home into two partitions.
NixOS store lives in / and might grow quite a bit, so a generous 60GB there.
This means we'll be using LVM (Logical Volume Manager) to manage the partitions,
whereas we had only one partition for UTM.

Use `lsblk` to see the disks available. `nvme0n1` is likely the SSD.

```bash
# --- Partitioning (ESP + LUKS container) ---
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 513MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 513MiB 100%

# Result:
# /dev/nvme0n1p1 -> EFI System Partition
# /dev/nvme0n1p2 -> LUKS container

# --- LUKS on /dev/nvme0n1p2 ---
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 cryptroot

# --- LVM inside LUKS ---
pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -L 60G  -n lv_root vg0
lvcreate -L 34G  -n lv_swap vg0
lvcreate -l 100%FREE -n lv_home vg0

# --- Filesystems ---
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/vg0/lv_root
mkfs.ext4 /dev/vg0/lv_home
mkswap /dev/vg0/lv_swap

# --- Mount for installation ---
mount /dev/vg0/lv_root /mnt
mkdir -p /mnt/{home,boot}
mount /dev/vg0/lv_home /mnt/home
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/vg0/lv_swap

# --- Generate initial NixOS config ---
nixos-generate-config --root /mnt
```