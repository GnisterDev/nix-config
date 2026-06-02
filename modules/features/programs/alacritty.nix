{ inputs, ... }:
{
  flake.modules.nixos.alacritty = {pkgs, ...}: {
    environment.systemPackages = [ pkgs.alacritty ];
  };

  flake.modules.homeManager.alacritty = { pkgs, ... }: {
    programs.alacritty = {
      enable = true;
    };
  };
}