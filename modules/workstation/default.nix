# Provides a password-authenticated Wayland login to Niri.
{ config, lib, pkgs, ... }:
{
  options.profiles.workstation.enable = lib.mkEnableOption "the shared workstation profile";

  config = lib.mkIf config.profiles.workstation.enable {
    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    services.greetd = {
      enable = true;
      settings.default_session.command = lib.escapeShellArgs [
        (lib.getExe pkgs.cage)
        "-s"
        "--"
        (lib.getExe pkgs.gtkgreet)
        "-c"
        "${config.programs.niri.package}/bin/niri-session"
      ];
    };

    # Override greetd's module default so PAM requires an account password.
    security.pam.services.greetd.allowNullPassword = lib.mkForce false;
    security.rtkit.enable = true;

    environment = {
      etc."niri/config.kdl".text = builtins.readFile ./niri.kdl;
      etc."noctalia/config.toml".source = ./noctalia.toml;
      systemPackages = [
        pkgs.firefox
        pkgs.foot
        pkgs.git
        pkgs.noctalia
      ];
    };
  };
}
