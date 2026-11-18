# Configures the installed ThinkPad console system and its boot mounts.
{
  imports = [
    (import ./disk-layout.nix { device = "/dev/disk/by-id/thinkpad-install-target"; })
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

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

  networking = {
    hostName = "thinkpad";
    networkmanager.enable = true;
  };
  services.resolved.enable = true;

  users.mutableUsers = true;
  users.users.root.hashedPassword = "!";
  security.sudo.wheelNeedsPassword = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";
}
