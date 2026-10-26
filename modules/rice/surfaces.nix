{
  flake.modules.homeManager.workstation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      p = config.rice.current;
      colors = config.lib.stylix.colors;
      c = colors.withHashtag;
      rgba =
        slot: alpha:
        "rgba(${colors."${slot}-rgb-r"}, ${colors."${slot}-rgb-g"}, ${colors."${slot}-rgb-b"}, ${toString alpha})";
      px = n: "${toString n}px";
      dark = p.polarity == "dark";
      pad = toString (p.gaps + 4);
    in
    {
      programs.fuzzel.settings = {
        main = {
          prompt = ''"❯  "'';
          icon-theme = if dark then p.icons.dark else p.icons.light;
        };
        border = {
          inherit (p.border) width;
          inherit (p) radius;
        };
      };

      services.mako.settings = {
        border-radius = p.radius;
        border-size = p.border.width;
      };

      programs.foot.settings.main.pad = "${pad}x${pad} center";

      programs.swaylock.settings = {
        font = p.fonts.sans.name;
      }
      // lib.optionalAttrs p.lock.blur {
        screenshots = true;
        effect-blur = "10x4";
        effect-vignette = "0.3:0.6";
      };

      programs.wlogout.style = ''
        * { background-image: none; box-shadow: none; font-family: "${p.fonts.sans.name}"; }
        window { background-color: ${rgba "base00" 0.8}; }
        button {
          color: ${c.base05};
          background-color: ${if dark then rgba "base01" 0.9 else rgba "base03" 0.9};
          border: ${px p.border.width} solid ${c.base02};
          border-radius: ${px p.radius};
          margin: ${px (p.gaps + 4)};
          background-repeat: no-repeat;
          background-position: center;
          background-size: 22%;
        }
        button:focus, button:active, button:hover {
          background-color: ${c.${p.accent}};
          color: ${c.base00};
          border-color: ${c.${p.accent}};
          outline-style: none;
        }
        ${lib.concatMapStrings
          (b: ''
            #${b} { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${b}.png")); }
          '')
          [
            "lock"
            "logout"
            "suspend"
            "reboot"
            "shutdown"
          ]
        }
      '';

      editor.neovim = {
        palette =
          if p.nvim.colorscheme == null then
            lib.filterAttrs (name: _: builtins.match "base0[0-9A-F]" name != null) c
          else
            null;
        colorscheme = lib.mkIf (p.nvim.colorscheme != null) p.nvim.colorscheme;
        background = p.polarity;
        transparent = p.opacity.terminal < 1;
      };
    };
}
