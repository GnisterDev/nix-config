# Full development toolchain lives in modules/dev/
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcc
        gnumake
        pkg-config
      ];
    };
}
