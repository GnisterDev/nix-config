{ ... }:
{
  flake.modules.nixos.bootloader = { ... }: {
    boot.loader.grub = {
      enable  = true;
      device  = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.consoleLogLevel = 3;
    boot.kernelParams    = [ "quiet" "udev.log_level=3" ];
  };
}
