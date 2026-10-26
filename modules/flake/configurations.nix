# Hosts declare `configurations.nixos.<name>.module`
# This turns each one into `nixosConfigurations.<name>`.
{ config, inputs, lib, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
          description = "The host's top-level NixOS module.";
        };
      }
    );
    default = { };
    description = "NixOS hosts, keyed by hostname.";
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    name:
    { module, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        module
        { networking.hostName = lib.mkDefault name; }
      ];
    }
  ) config.configurations.nixos;
}
