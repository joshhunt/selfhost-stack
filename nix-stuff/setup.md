Following https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS.html

```shell
$ find /dev/disk/by-id/

/dev/disk/by-id/
/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_040147a18165869c83436d0b528ac1a03dba1b43f8676c7f5a4717e4673ec67dd4d100000000000000000000bca7eb4a000e021891558107ca2efed3-0:0-part1
/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_040147a18165869c83436d0b528ac1a03dba1b43f8676c7f5a4717e4673ec67dd4d100000000000000000000bca7eb4a000e021891558107ca2efed3-0:0-part2
/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_040147a18165869c83436d0b528ac1a03dba1b43f8676c7f5a4717e4673ec67dd4d100000000000000000000bca7eb4a000e021891558107ca2efed3-0:0
/dev/disk/by-id/nvme-KIOXIA-EXCERIA_PLUS_G4_SSD_YEQKF1YKZ23M
/dev/disk/by-id/nvme-KIOXIA-EXCERIA_PLUS_G4_SSD_YEQKF1YKZ23M_1
/dev/disk/by-id/nvme-eui.00000000000000008ce38e05015417ef
```


Going to use `/dev/disk/by-id/nvme-eui.00000000000000008ce38e05015417ef`


```sh
DISK='/dev/disk/by-id/nvme-eui.00000000000000008ce38e05015417ef'
MNT=$(mktemp -d)
SWAPSIZE=4
RESERVE=1

# --

partition_disk () {
 local disk="${1}"
 blkdiscard -f "${disk}" || true

 parted --script --align=optimal  "${disk}" -- \
 mklabel gpt \
 mkpart EFI 1MiB 4GiB \
 mkpart rpool 4GiB -$((SWAPSIZE + RESERVE))GiB \
 mkpart swap  -$((SWAPSIZE + RESERVE))GiB -"${RESERVE}"GiB \
 set 1 esp on \

 partprobe "${disk}"
}

for i in ${DISK}; do
   partition_disk "${i}"
done

# ---

for i in ${DISK}; do
   cryptsetup open --type plain --key-file /dev/random "${i}"-part3 "${i##*/}"-part3
   mkswap /dev/mapper/"${i##*/}"-part3
   swapon /dev/mapper/"${i##*/}"-part3
done

# --

zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R "${MNT}" \
    -O acltype=posixacl \
    -O canmount=off \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=none \
    -O compression=zstd \
    rpool \
   $(for i in ${DISK}; do
      printf '%s ' "${i}-part2";
     done)


# --

zfs create -o canmount=noauto -o mountpoint=legacy rpool/root

zfs create -o mountpoint=legacy rpool/home
mount -o X-mount.mkdir -t zfs rpool/root "${MNT}"
mount -o X-mount.mkdir -t zfs rpool/home "${MNT}"/home

# --

for i in ${DISK}; do
 mkfs.vfat -n EFI "${i}"-part1
done

for i in ${DISK}; do
 mount -t vfat -o fmask=0077,dmask=0077,iocharset=iso8859-1,X-mount.mkdir "${i}"-part1 "${MNT}"/boot
 break
done

# -- 

nixos-generate-config --root "${MNT}" --flake --force

# --

nixos-install --root "${MNT}" --flake "${MNT}/etc/nixos/flake.nix#nixos"

# --

cd /
umount -Rl "${MNT}"
zpool export -a
```