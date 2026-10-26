{
  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      rice.profiles.nord = {
        description = "Nord · frosted glass, translucent floating bottom bar";
        polarity = "dark";
        scheme = "nord";
        accent = "base0C";
        accent2 = "base0D";

        wallpaper = {
          generate = "gradient";
          colors = [
            "base00"
            "base03"
          ];
          transition = "wave";
        };

        fonts = {
          mono = {
            name = "Hack Nerd Font";
            package = pkgs.nerd-fonts.hack;
          };
          sans = {
            name = "Roboto";
            package = pkgs.roboto;
          };
        };

        cursor = {
          name = "Bibata-Modern-Ice";
          package = pkgs.bibata-cursors;
        };

        opacity = {
          terminal = 0.85;
          bar = 0.7;
          popups = 0.9;
          inactive = 0.92;
        };

        gaps = 8;
        radius = 8;

        bar = {
          style = "islands";
          position = "bottom";
          height = 34;
        };
      };
    };
}
