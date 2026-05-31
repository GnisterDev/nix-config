_:
{
  flake.modules.nixos.bootloader = _: {
    boot = {
      loader.grub = {
        enable  = true;
        device  = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 10;
      };
      loader.efi.canTouchEfiVariables = true;
      consoleLogLevel = 3;
      kernelParams    = [ "quiet" "udev.log_level=3" ];
    };
  };
}
