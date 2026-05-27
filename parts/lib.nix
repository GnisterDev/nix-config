{ inputs, lib, ... }:
let
  hmModule = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
    };
  };

  commonModules = [
    inputs.self.modules.generic.constants
    inputs.home-manager.nixosModules.home-manager
    hmModule
    inputs.agenix.nixosModules.default
  ];

  mkSystem = system: extraModules: host:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = commonModules ++ extraModules ++ [
        inputs.self.modules.nixos.${host}
      ];
    };

in
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkNixos = system: host:
      mkSystem system [
        inputs.niri-flake.nixosModules.niri
      ] host;

    mkNixosWsl = system: host:
      mkSystem system [
        inputs.nixos-wsl.nixosModules.default
      ] host;
  };
}