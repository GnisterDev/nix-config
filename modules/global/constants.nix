{ lib, ... }:
{
  flake.modules.generic.constants = { lib, ... }: {
    options.systemConstants = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "gnister";
      };

      gitName = lib.mkOption {
        type = lib.types.str;
        default = "gnister";
      };

      gitEmail = lib.mkOption {
        type = lib.types.str;
        default = "sscharer@online.no";
      };

      # niriOutputsFile = lib.mkOption {
      #   type = lib.types.path;
      #   default = ../../modules/niri-config/outputs.kdl;
      # };

      timezone        = lib.mkDefault "Europe/Oslo";
      defaultLocale   = lib.mkDefault "en_US.UTF-8";
      extraLocale     = lib.mkDefault "nb_NO.UTF-8";
      keyMap          = lib.mkDefault "no";
    };
    # config.systemConstants = {};
  };
}