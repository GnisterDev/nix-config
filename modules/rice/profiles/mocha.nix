{
  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      rice.profiles.mocha = {
        description = "Catppuccin Mocha · pastel islands, gradient ring, blurred blobs";
        polarity = "dark";
        scheme = "catppuccin-mocha";
        accent = "base0E";
        accent2 = "base0D";

        wallpaper = {
          generate = "blobs";
          colors = [
            "base00"
            "base0E"
            "base0D"
            "base0F"
          ];
          transition = "grow";
        };

        fonts = {
          mono = {
            name = "JetBrainsMono Nerd Font";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };
          sans = {
            name = "Inter";
            package = pkgs.inter;
          };
          size = {
            terminal = 12;
            ui = 11;
          };
        };

        cursor = {
          name = "catppuccin-mocha-dark-cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
        };

        opacity = {
          terminal = 0.92;
          bar = 0.85;
          popups = 0.95;
          inactive = 0.96;
        };

        gaps = 10;
        radius = 12;
        border = {
          kind = "ring";
          width = 2;
          gradient = true;
        };

        bar = {
          style = "islands";
          position = "top";
          height = 36;
        };

        nvim.colorscheme = "catppuccin-mocha";
      };
    };
}
