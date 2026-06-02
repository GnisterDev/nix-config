{ inputs, ... }:
let
  system = inputs.self.constants.system;
in
{
  flake.modules.nixos.common = { pkgs, ... }: {
    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    time.timeZone      = system.timeZone;
    i18n.defaultLocale = system.defaultLocale;
    i18n.extraLocaleSettings.LC_TIME = system.extraLocales.LC_TIME;

    environment.systemPackages = with pkgs; [
      wget
      curl
      ripgrep
      fd
    ];
  };
}