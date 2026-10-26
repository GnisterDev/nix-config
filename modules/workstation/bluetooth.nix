{
  flake.modules.nixos.workstation =
    { lib, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = lib.mkDefault true;
      };
      # blueman-manager + tray applet (started via XDG autostart).
      services.blueman.enable = true;
    };
}
