{ config, ... }:
let
  inherit (config.constants) locale;
in
{
  flake.modules.nixos.base = {
    time.timeZone = locale.timeZone;
    i18n = {
      defaultLocale = locale.default;
      extraLocaleSettings = locale.extra;
    };
    console.keyMap = locale.keyboard.layout;
  };
}
