{ lib, ... }:
{
  options.flake = {
    # Accessed as: inputs.self.modules.nixos.<name>
    # Used in: NixOS host imports
    modules.nixos = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
    };

    # Accessed as: inputs.self.modules.homeManager.<name>
    # Used in: home-manager.sharedModules / home-manager.users.<user>.imports
    modules.homeManager = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
    };

    # Accessed as: inputs.self.modules.generic.<name>
    # Used in: constants and library aspects that need no class-specific options.
    # Must be imported into every class (nixos + homeManager) that needs them.
    modules.generic = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
    };
  };
}
