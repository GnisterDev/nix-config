{ inputs, lib, ... }:
{
  # Expose helper functions so configurations.nix (and the user) can call them.
  #
  # inputs.self.lib.mkNixos "x86_64-linux" "laptop"
  # -> calls nixpkgs.lib.nixosSystem wiring in home-manager, agenix, niri, etc.
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    # Build a NixOS system from a host aspect module.
    #
    #   system  - e.g. "x86_64-linux"
    #   host    - the key in flake.modules.nixos (also the hostname)
    mkNixos = system: host:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          inputs.self.modules.generic.constants # Global constants (generic -> nixos bridge)
          inputs.home-manager.nixosModules.home-manager # Home Manager NixOS module
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; }; # Pass inputs into every HM module so aspects can reference them.
            };
          }
          
          inputs.agenix.nixosModules.default # Agenix secrets
          inputs.niri-flake.nixosModules.niri # Niri overlay + NixOS module
          inputs.self.modules.nixos.${host} # The host's own aspect (contains all its imports)
        ];
      };

    # Like mkNixos but also wires in the NixOS-WSL module.
    mkNixosWsl = system: host:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          inputs.self.modules.generic.constants
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
            };
          }
          inputs.agenix.nixosModules.default
          inputs.nixos-wsl.nixosModules.default
          inputs.self.modules.nixos.${host}
        ];
      };
  };
}
