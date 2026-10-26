{ config, inputs, ... }:
{
  configurations.nixos.laptop.module = {
    imports =
      (with config.flake.modules.nixos; [
        base
        dev
        metal
        workstation
        laptop
        # secure-boot  # after `sbctl create-keys`, see modules/laptop/secure-boot.nix
      ])
      ++ (with inputs.nixos-hardware.nixosModules; [
        common-cpu-intel
        common-pc-laptop
        common-pc-laptop-ssd
      ])
      ++ [ ./_hardware.nix ];

    workstation = {
      profile = "mocha";
      outputs = ''
        // output "eDP-1" {
        //     mode "2560x1600@165.003"
        //     scale 2.0
        // }
      '';
    };

    system.stateVersion = "26.05";
  };
}
