{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # nil, nixfmt, statix and deadnix are in base (modules/base/nix-tools.nix)
        lua-language-server
        stylua
        typescript-language-server
        typescript
        basedpyright
        ruff
        rust-analyzer
        gopls
        clang-tools # clangd, clang-format
        bash-language-server
        yaml-language-server
        taplo
        marksman
      ];
    };
}
