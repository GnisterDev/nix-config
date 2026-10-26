# Host that imports `nixos.<aspect>` also loads `homeManager.<aspect>`
{ config, lib, ... }:
{
  flake.modules.nixos = lib.mapAttrs (_aspect: hmModule: {
    home-manager.sharedModules = [ hmModule ];
  }) config.flake.modules.homeManager;
}
