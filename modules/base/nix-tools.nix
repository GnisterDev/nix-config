# Formatting, linting and language-server support for Nix
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixfmt
        statix
        deadnix
        nil
        nix-tree
      ];
    };
}
