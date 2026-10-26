# GRUB on EFI, with os-prober so a Windows install on the same disk shows up.
# (modules/laptop/secure-boot.nix swaps this for lanzaboote.)
{
  flake.modules.nixos.metal =
    { lib, ... }:
    {
      boot = {
        loader = {
          grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            useOSProber = lib.mkDefault true;
            configurationLimit = 10;
          };
          efi.canTouchEfiVariables = true;
        };
        consoleLogLevel = 3;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
        ];
        tmp.cleanOnBoot = true;
      };

      zramSwap.enable = true;
    };
}
