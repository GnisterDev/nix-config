{ inputs, ... }:
{
  flake.modules.nixos.niri = { pkgs, ... }: {
    imports = [ inputs.niri.nixosModules.niri ];

    programs.niri = {
      enable  = true;
      package = inputs.niri.packages.${pkgs.system}.niri-stable;
    };

    xdg.portal = {
      enable        = true;
      extraPortals  = [ pkgs.xdg-desktop-portal-gtk ]; # or `pkgs.xdg-desktop-portal-gnome`  
      config.common.default = "*";
    };

    services.pipewire = {
      enable             = true;
      alsa.enable        = true;
      alsa.support32Bit  = true;
      pulse.enable       = true;
      wireplumber.enable = true;
    };

    security.pam.services.swaylock = { };

    environment.systemPackages = with pkgs; [
      waybar brightnessctl playerctl
      wofi mako swaylock swayidle
      wl-clipboard grim slurp awww
    ];

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.niri
    ];
  };

  flake.modules.homeManager.niri = { pkgs, ... }: {
    xdg.configFile.niri = {
      source    = inputs.self.lib.checkKDLDir pkgs ./config "config.kdl";
      recursive = true;
    };
  };
}
