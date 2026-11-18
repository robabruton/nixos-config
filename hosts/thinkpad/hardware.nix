# Enables the ThinkPad X1 Carbon Gen 9 display, input, and suspend policy.
{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "i915" ];

  hardware = {
    graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };
    trackpoint.enable = true;
  };

  services = {
    libinput.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "ignore";
    };
  };
}
