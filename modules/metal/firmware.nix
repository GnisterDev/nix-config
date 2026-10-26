{
  flake.modules.nixos.metal = {
    hardware.enableRedistributableFirmware = true;
    services.fwupd.enable = true;
  };
}
