{ inputs, ... }:
{
  flake.modules.nixos.theme = { pkgs, ... }: {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.theme
    ];
  };

  flake.modules.homeManager.theme = { pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };
    };

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };
  };
}
