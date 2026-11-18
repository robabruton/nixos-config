# Defines the shared partition and mount layout for Disko and NixOS.
{ device, passphraseFile ? null }:
let
  mountOptions = [ "compress=zstd:1" "nodiscard" ];
in
{
  disko.devices.disk.main = {
    type = "disk";
    inherit device;
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "4G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        system = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            passwordFile = passphraseFile;
            extraFormatArgs = [ "--type" "luks2" ];
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/root" = { mountpoint = "/"; inherit mountOptions; };
                "/home" = { mountpoint = "/home"; inherit mountOptions; };
                "/nix" = { mountpoint = "/nix"; inherit mountOptions; };
                "/log" = { mountpoint = "/var/log"; inherit mountOptions; };
                "/snapshots" = { mountpoint = "/.snapshots"; inherit mountOptions; };
              };
            };
          };
        };
      };
    };
  };
}
