{ config, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        flake = config.constants.flakeDir;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 7d --keep 10";
        };
      };

      environment.systemPackages = with pkgs; [
        nix-output-monitor
        nvd
      ];
    };
}
