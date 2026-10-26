{
  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      rice.profiles.rose-pine-dawn = {
        description = "Rosé Pine Dawn · light and airy, wide gaps, minimal bar";
        polarity = "light";
        scheme = "rose-pine-dawn";
        accent = "base0D";
        accent2 = "base0C";

        wallpaper = {
          generate = "radial";
          colors = [
            "base00"
            "base02"
          ];
          transition = "fade";
        };

        fonts = {
          mono = {
            name = "CaskaydiaCove Nerd Font";
            package = pkgs.nerd-fonts.caskaydia-cove;
          };
          sans = {
            name = "Noto Sans";
            package = pkgs.noto-fonts;
          };
          size = {
            terminal = 12;
            ui = 11;
          };
        };

        cursor = {
          name = "phinger-cursors-dark";
          package = pkgs.phinger-cursors;
        };

        opacity.terminal = 0.97;

        gaps = 16;
        radius = 16;
        border.width = 3;

        bar = {
          style = "minimal";
          position = "top";
          height = 30;
        };

        nvim.colorscheme = "rose-pine-dawn";
      };
    };
}
