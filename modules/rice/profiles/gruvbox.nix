{
  flake.modules.homeManager.workstation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          rice.profiles.gruvbox = {
            description = "Gruvbox · warm retro, square corners, docked bottom bar";
            polarity = "dark";
            scheme = "gruvbox-dark-medium";
            accent = "base0A";
            accent2 = "base09";

            wallpaper = {
              generate = "radial";
              colors = [
                "base00"
                "base02"
              ];
              transition = "wipe";
            };

            fonts = {
              mono = {
                name = "FiraCode Nerd Font";
                package = pkgs.nerd-fonts.fira-code;
              };
              sans = {
                name = "IBM Plex Sans";
                package = pkgs.ibm-plex;
              };
              size = {
                terminal = 12;
                ui = 11;
              };
            };

            cursor = {
              name = "Bibata-Modern-Amber";
              package = pkgs.bibata-cursors;
            };

            gaps = 6;
            radius = 0;
            border = {
              kind = "border";
              width = 3;
            };
            shadow = false;

            bar = {
              style = "docked";
              position = "bottom";
              height = 30;
            };

            lock.blur = false;
            nvim.colorscheme = "gruvbox";
          };
        }

        (lib.mkIf (config.rice.active == "gruvbox") {
          programs.foot.settings.cursor = {
            style = "block";
            blink = "yes";
          };
        })
      ];
    };
}
