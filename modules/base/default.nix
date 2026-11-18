{
  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.mutableUsers = true;
  users.users.root.hashedPassword = "!";
  security.sudo.wheelNeedsPassword = true;
}
