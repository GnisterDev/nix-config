{
  flake.modules.nixos.base =
    { lib, ... }:
    {
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          trusted-users = [
            "root"
            "@wheel"
          ];
          warn-dirty = false;
        };
        # Flakes only; `nixpkgs` in the registry/NIX_PATH follows this flake's lock
        channel.enable = false;
      };

      nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = lib.mkDefault "x86_64-linux";
      };
    };
}
