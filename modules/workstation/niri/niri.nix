{
  flake.modules.nixos.workstation =
    { lib, pkgs, ... }:
    {
      options.workstation.outputs = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "niri `output` blocks for this machine (see `niri msg outputs`).";
        example = ''
          output "eDP-1" {
              mode "2560x1600@165.003"
              scale 1.6
          }
        '';
      };

      config = {
        programs.niri.enable = true;

        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
          ];
        };

        # niri starts xwayland-satellite on demand when it is on PATH.
        environment.systemPackages = [ pkgs.xwayland-satellite ];

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
      };
    };

  flake.modules.homeManager.workstation =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      cfg = config.niri;
      niri = osConfig.programs.niri.package;

      configDir =
        pkgs.runCommandLocal "niri-config"
          {
            nativeBuildInputs = [ niri ];
          }
          ''
            mkdir -p $out
            cp -r ${./config}/. $out/
            chmod -R u+w $out
            ${lib.concatStrings (
              lib.mapAttrsToList (name: text: ''
                cp ${pkgs.writeText name text} $out/${name}
              '') cfg.includes
            )}
            niri validate --config $out/config.kdl
          '';
    in
    {
      options.niri.includes = lib.mkOption {
        type = lib.types.attrsOf lib.types.lines;
        default = { };
        description = "Generated KDL files placed next to config.kdl (which includes them).";
      };

      config = {
        niri.includes."outputs.kdl" = osConfig.workstation.outputs;

        xdg.configFile.niri = {
          source = configDir;
          recursive = true;
        };
      };
    };
}
