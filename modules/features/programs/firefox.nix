{ inputs, ... }:
{
  flake.modules.nixos.forefox = {pkgs, ...}: {
    environment.systemPackages = [ pkgs.forefox ];
  };

  flake.modules.homeManager.forefox = { pkgs, ... }: {
    programs.forefox = {
      enable = true;
      languagePacks = ["en-GB" "en-US" "nb-NO"]
    };
  };
}