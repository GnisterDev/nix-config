{ config, ... }:
{
  configurations.nixos.desktop.module =
    { lib, pkgs, ... }:
    {
      imports =
        (with config.flake.modules.nixos; [
          base
          dev
          metal
          workstation
          gaming
          creative
          virtualisation
        ])
        ++ [ ./_hardware.nix ];

      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      workstation = {
        profile = "gruvbox";
        outputs = ''
          // output "DP-1" {
          //     mode "2560x1440@144.001"
          //     position x=0 y=0
          // }
        '';
      };

      system.stateVersion = "26.05";
    };
}
