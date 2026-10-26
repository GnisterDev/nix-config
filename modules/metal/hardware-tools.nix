{
  flake.modules.nixos.metal =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        lm_sensors
        smartmontools
        nvme-cli
        pciutils
        usbutils
      ];

      services.smartd.enable = true;
    };
}
