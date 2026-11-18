# ThinkPad installation and recovery

The ThinkPad installer uses the Disko revision in `flake.lock` for disk
creation and the installed NixOS module. The layout is a 4 GiB FAT32 EFI
system partition mounted at `/boot` and a LUKS2 container occupying the
remaining space. The EFI partition is unencrypted. The normal passphrase
unlocks the system volume before NixOS mounts the Btrfs subvolumes.

| Btrfs subvolume | Mount point |
| --- | --- |
| `/root` | `/` |
| `/home` | `/home` |
| `/nix` | `/nix` |
| `/log` | `/var/log` |
| `/snapshots` | `/.snapshots` |

## Install

Boot official NixOS live media in UEFI mode. Have network access for the
pinned build and a writable, separately mounted recovery volume. Verify the
backup of any data on the disk you select. Use a dedicated target disk and
keep the Fedora disk out of the installation target. This workflow erases
the entire selected disk.

From the repository checkout, replace the two example paths with the target
disk's by-ID path and the recovery volume's mount point.

```sh
sudo nix --extra-experimental-features 'nix-command flakes' run \
  .#install-thinkpad -- \
  --disk /dev/disk/by-id/TARGET_DISK \
  --recovery-destination /run/media/nixos/RECOVERY
```

Choose your login name when prompted. The installer builds the locked
system and displays the selected disk. It accepts only the exact
`ERASE /dev/…` phrase printed for that disk.

Choose a disk boot passphrase and a separate passphrase for the `age`
archive. The installer adds a random recovery key in a separate LUKS slot
and verifies the archive before installing. At the end, enter your login
password at the `passwd` prompt. Root password login is locked. Keep the
verified archive on media separate from the laptop.

When installation succeeds, shut down, remove the live media, and boot
from the target. Enter your disk passphrase, log in using your chosen
account, and verify `sudo`. The installed flake in `/etc/nixos` includes
the local account declaration and the project lock. It contains no
password or password hash. Rebuild from that same installed flake.

```sh
sudo nixos-rebuild switch --flake path:/etc/nixos#thinkpad
```

## Recover from separate media

Use trusted live media with `age`, `cryptsetup`, and Btrfs tools available
offline. The archive contains `recovery-key.txt`, `luks-header.img`,
`recovery.txt`, and `SHA256SUMS`. Decrypt into a private directory in the
live system's RAM-backed `/run`. Verify the manifest, then compare the
container UUID in `recovery.txt` with `cryptsetup luksUUID` for the disk
you intend to recover.

The examples below use the installed GPT label. Replace the archive path
with the actual file on the mounted recovery volume. Run from a root shell
on the trusted live system.

```sh
umask 077
work=$(mktemp -d --tmpdir=/run thinkpad-recovery.XXXXXX)
age --decrypt --output "$work/recovery.tar" /mnt/recovery/ARCHIVE.tar.age
tar -xf "$work/recovery.tar" -C "$work"
(cd "$work" && sha256sum --check SHA256SUMS)
cat "$work/recovery.txt"
partition=/dev/disk/by-partlabel/disk-main-system
cryptsetup luksUUID "$partition"
```

Continue only after the checksums and UUID match. To check access using the
archived header, open it as a detached header and mount the desired
subvolume read-only. Omit the `--header` argument to use the disk's live
header instead.

```sh
mkdir "$work/mount"
cryptsetup open --readonly --header "$work/luks-header.img" \
  --key-file "$work/recovery-key.txt" "$partition" thinkpad-recovery
mount -o ro,rescue=nologreplay,subvol=/root /dev/mapper/thinkpad-recovery "$work/mount"
ls -la "$work/mount"
umount "$work/mount"
cryptsetup close thinkpad-recovery
```

Shut down the live environment to discard the decrypted files in RAM. The
header archive provides access to an intact encrypted volume. Keep an
independent data backup for disk loss or failure.
