{ lib, ... }:
{
  imports = [ ../../modules/workstation ];

  profiles.workstation.enable = true;
  environment.etc."niri/config.kdl".text = lib.mkAfter (builtins.readFile ./niri.kdl);
}
