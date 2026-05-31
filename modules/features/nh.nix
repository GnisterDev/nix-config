{ inputs, ... }:
{
  flake.modules.nixos.nh = {pkgs, ...}: {
    environment.systemPackages = [ pkgs.nh ];
    programs.nh = {
      enable      = true;
      flake       = "/etc/nixos";
      clean = {
        enable    = true;
        dates     = "weekly";
        extraArgs = "--keep-since 4d --keep 10";
      };
    };
  };
}
