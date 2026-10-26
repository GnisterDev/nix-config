{
  flake.modules.homeManager.workstation =
    { config, lib, ... }:
    let
      p = config.rice.current;
      c = config.lib.stylix.colors.withHashtag;
      flag = on: if on then "on" else "off";
      ring = p.border.kind == "ring";

      colours = ''
        ${
          if p.border.gradient then
            ''active-gradient from="${c.${p.accent}}" to="${c.${p.accent2}}" angle=45 relative-to="workspace-view"''
          else
            ''active-color "${c.${p.accent}}"''
        }
                inactive-color "${c.base03}"
                urgent-color "${c.base08}"'';
    in
    {
      niri.includes."rice.kdl" = ''
        // Generated from rice profile "${config.rice.active}".
        // Edit modules/rice/profiles/${config.rice.active}.nix instead.

        layout {
            gaps ${toString p.gaps}

            focus-ring {
                ${flag ring}
                width ${toString p.border.width}
                ${colours}
            }

            border {
                ${flag (!ring)}
                width ${toString p.border.width}
                ${colours}
            }

            shadow {
                ${flag p.shadow}
                softness 30
                spread 4
                offset x=0 y=6
                color "#00000070"
            }

            tab-indicator {
                active-color "${c.${p.accent}}"
                inactive-color "${c.base03}"
            }

            insert-hint {
                color "${c.${p.accent}}80"
            }
        }

        overview {
            backdrop-color "${c.base00}"
        }

        cursor {
            xcursor-theme "${p.cursor.name}"
            xcursor-size ${toString p.cursor.size}
        }

        window-rule {
            geometry-corner-radius ${toString p.radius}
            clip-to-geometry true
        }
      ''
      + lib.optionalString (p.opacity.inactive < 1) ''

        window-rule {
            match is-active=false
            opacity ${toString p.opacity.inactive}
        }
      '';
    };
}
