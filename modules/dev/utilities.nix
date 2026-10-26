{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        shellcheck
        shfmt
        pre-commit
        just
      ];
    };
}
