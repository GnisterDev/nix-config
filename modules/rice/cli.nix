{ config, ... }:
let
  inherit (config.constants) flakeDir;
in
{
  flake.modules.homeManager.workstation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.rice.package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        internal = true;
      };

      config = {
        rice.package = pkgs.writeShellApplication {
          name = "rice";
          runtimeInputs = with pkgs; [
            coreutils
            findutils
            gnugrep
            gnused
            jq
            yq-go
            util-linux # flock
            libnotify
            git
            config.programs.fuzzel.package
            config.services.mako.package
          ];
          text = ''
            RICE_DEFAULT_FLAKE=${lib.escapeShellArg flakeDir}
            RICE_SCHEMES=${pkgs.base16-schemes}/share/themes
          ''
          + builtins.readFile ./rice.sh;
        };

        home.packages = [ config.rice.package ];
      };
    };
}
