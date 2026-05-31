{ lib, ... }:
{
  options.flake.constants = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.constants = {
    user = {
      name     = "gnister";
      email    = "sscharer@online.no";
      username = "gnister";
    };

    system = {
      version = "25.11";
      timeZone      = "Europe/Oslo";
      defaultLocale = "en_US.UTF-8";
      extraLocales  = {
        LC_TIME = "nb_NO.UTF-8";
      };
    };

    keyboard = {
      layout  = "no";
      options = "";
    };
  };
}
