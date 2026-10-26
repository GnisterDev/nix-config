{
  flake.modules.nixos.laptop = {
    services.thermald.enable = true;

    hardware.bluetooth.powerOnBoot = false;

    workstation.idle = {
      lockAfter = 300;
      screenOffAfter = 360;
      suspendAfter = 900;
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
    };
  };
}
