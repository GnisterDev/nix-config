{ inputs, ... }:
{
  flake.modules.nixos.firefox = {pkgs, ...}: {
    environment.systemPackages = [ pkgs.firefox ];
  };

  flake.modules.homeManager.firefox = { pkgs, ... }: {
    programs.firefox = {
      enable = true;
      languagePacks = ["en-GB" "en-US" "nb-NO"];
    };
  };
}
