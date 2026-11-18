# Configures the installed ThinkPad console system and its boot mounts.
{
  imports = [
    ../../modules/base
    (import ./disk-layout.nix { device = "/dev/disk/by-id/thinkpad-install-target"; })
    ./hardware.nix
    ./graphical.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" ];
      systemd.enable = true;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  fileSystems."/nix".neededForBoot = true;

  networking.hostName = "thinkpad";
  system.stateVersion = "26.05";
}
