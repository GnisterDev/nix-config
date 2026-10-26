{
  flake.modules.homeManager.workstation =
    { config, lib, ... }:
    let
      p = config.rice.current;
      colors = config.lib.stylix.colors;
      c = colors.withHashtag;
      rice = lib.getExe config.rice.package;

      rgba =
        slot: alpha:
        "rgba(${colors."${slot}-rgb-r"}, ${colors."${slot}-rgb-g"}, ${colors."${slot}-rgb-b"}, ${toString alpha})";
      px = n: "${toString n}px";

      glyph = code: builtins.fromJSON ''"\u${code}"'';

      inherit (p.bar) style position;
      minimal = style == "minimal";
      top = position == "top";

      settings = {
        layer = "top";
        inherit position;
        inherit (p.bar) height;
        spacing = 4;

        modules-left = [
          "custom/logo"
          "niri/workspaces"
        ]
        ++ lib.optional (!minimal) "niri/window";
        modules-center = [ "clock" ];
        modules-right =
          (
            if minimal then
              [
                "pulseaudio"
                "battery"
              ]
            else
              [
                "tray"
                "power-profiles-daemon"
                "pulseaudio"
                "network"
                "bluetooth"
                "battery"
              ]
          )
          ++ [
            "custom/rice"
            "custom/power"
          ];

        "custom/logo" = {
          format = glyph "f313";
          tooltip = false;
          on-click = "fuzzel";
        };
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = glyph "25cf";
            default = glyph "25cb";
          };
        };
        "niri/window" = {
          max-length = 48;
          separate-outputs = true;
        };
        clock = {
          format = "${glyph "f017"}  {:%H:%M}";
          format-alt = "${glyph "f073"}  {:%A %d %B}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "${glyph "f026"}  muted";
          format-icons.default = map glyph [
            "f026"
            "f027"
            "f028"
          ];
          on-click = "pavucontrol";
          scroll-step = 5;
        };
        network = {
          format-wifi = "${glyph "f1eb"}  {essid}";
          format-ethernet = "${glyph "f0e8"}  wired";
          format-disconnected = "${glyph "f127"}  offline";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };
        bluetooth = {
          format = glyph "f293";
          format-disabled = "";
          format-connected = "${glyph "f293"}  {num_connections}";
          on-click = "blueman-manager";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "${glyph "f0e7"}  {capacity}%";
          format-icons = map glyph [
            "f244"
            "f243"
            "f242"
            "f241"
            "f240"
          ];
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          format-icons = {
            default = glyph "f0e7";
            performance = glyph "f0e7";
            balanced = glyph "f24e";
            power-saver = glyph "f06c";
          };
        };
        tray = {
          spacing = 8;
          icon-size = 16;
        };
        "custom/rice" = {
          exec = "${rice} current";
          interval = "once";
          format = "${glyph "f1fc"}  {}";
          tooltip-format = "Rice profile · click: pick · scroll / right-click: cycle";
          on-click = "${rice} pick";
          on-click-right = "${rice} next";
          on-scroll-up = "${rice} next";
          on-scroll-down = "${rice} prev";
        };
        "custom/power" = {
          format = glyph "f011";
          tooltip = false;
          on-click = "wlogout -b 5";
        };
      }
      // lib.optionalAttrs (style == "islands") {
        margin-left = p.gaps;
        margin-right = p.gaps;
        ${if top then "margin-top" else "margin-bottom"} = p.gaps;
      };

      common = ''
        * {
          font-family: "${p.fonts.mono.name}", "Symbols Nerd Font";
          font-size: ${px (p.fonts.size.ui + 2)};
          min-height: 0;
          border: none;
          border-radius: 0;
        }

        tooltip {
          background: ${rgba "base00" p.opacity.popups};
          border: 1px solid ${c.${p.accent}};
          border-radius: ${px p.radius};
        }
        tooltip label { color: ${c.base05}; }

        #workspaces button {
          padding: 0 6px;
          color: ${c.base03};
          background: transparent;
          box-shadow: none;
        }
        #workspaces button.active { color: ${c.${p.accent}}; }
        #workspaces button.urgent { color: ${c.base08}; }
        #workspaces button:hover { background: ${rgba "base02" 0.6}; color: ${c.base05}; }

        #custom-logo { color: ${c.${p.accent}}; padding: 0 12px 0 10px; }
        #window { color: ${c.base04}; }
        #clock { color: ${c.base05}; }
        #pulseaudio { color: ${c.base0E}; }
        #network { color: ${c.base0C}; }
        #bluetooth { color: ${c.base0D}; }
        #battery { color: ${c.base0B}; }
        #battery.warning { color: ${c.base0A}; }
        #battery.critical:not(.charging) { color: ${c.base08}; }
        #power-profiles-daemon { color: ${c.base0A}; }
        #custom-rice { color: ${c.${p.accent2}}; }
        #custom-power { color: ${c.base08}; padding-right: 12px; }

        #window, #clock, #pulseaudio, #network, #bluetooth, #battery,
        #power-profiles-daemon, #tray, #custom-rice, #custom-power {
          padding-left: 10px;
          padding-right: 10px;
        }
      '';

      styles = {
        islands = ''
          window#waybar { background: transparent; color: ${c.base05}; }
          .modules-left, .modules-center, .modules-right {
            background: ${rgba "base00" p.opacity.bar};
            border: ${px p.border.width} solid ${c.base02};
            border-radius: ${px p.radius};
            padding: 0 4px;
          }
          #workspaces button.active {
            background: ${c.${p.accent}};
            color: ${c.base00};
            border-radius: ${px p.radius};
          }
        '';
        docked = ''
          window#waybar {
            background: ${rgba "base00" p.opacity.bar};
            color: ${c.base05};
            border-${if top then "bottom" else "top"}: ${px (lib.max 1 p.border.width)} solid ${c.base02};
          }
          #workspaces button.active { box-shadow: inset 0 ${if top then "-3px" else "3px"} ${c.${p.accent}}; }
        '';
        minimal = ''
          window#waybar { background: transparent; color: ${c.base05}; }
          #workspaces button { padding: 0 4px; }
        '';
      };

      css = common + styles.${style} + p.bar.extraCss;
    in
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = [ settings ];
        style = css;
      };

      # Restart the bar whenever the profile changes it.
      systemd.user.services.waybar.Unit.X-Restart-Triggers = [
        (builtins.hashString "sha256" (builtins.toJSON settings + css))
      ];
    };
}
