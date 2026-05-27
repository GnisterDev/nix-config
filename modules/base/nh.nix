{ pkgs, config, ... }:
{
  # flake.modules.nixos.nh = {
  #   programs.nh = {
  #     enable      = true;
  #     flake       = "/etc/nixos";
  #     clean = {
  #       enable    = true;
  #       dates     = "weekly";
  #       extraArgs = "--keep-since 4d --keep 10";
  #     };
  #   };

  #   environment.systemPackages = [ pkgs.nh ];
  # };

  environment.systemPackages = [ pkgs.nh ];

  environment.sessionVariables = {
    FLAKE = "/etc/nixos";
  };
}
