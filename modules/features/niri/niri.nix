{ inputs, ... }:
{
  flake.modules.nixos.niri = { pkgs, ... }: {
    imports = [ inputs.niri.nixosModules.niri ];

    programs.niri = {
      enable  = true;
      package = inputs.niri.packages.${pkgs.system}.niri;
    };

    xdg.portal = {
      enable        = true;
      extraPortals  = [ pkgs.xdg-desktop-portal-gnome ];
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
      wl-clipboard grim slurp
    ];

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.niri
    ];
  };

  flake.modules.homeManager.niri = _: {
    xdg.configFile = {
      "niri/config.kdl".source    = ./config/config.kdl;
      "niri/outputs.kdl".source   = ./config/outputs.kdl;
      "niri/keybinds.kdl".source  = ./config/keybinds.kdl;
      "niri/layout.kdl".source    = ./config/layout.kdl;
      "niri/rules.kdl".source     = ./config/rules.kdl;
      "niri/input.kdl".source     = ./config/input.kdl;
      "niri/animations.kdl".source = ./config/animations.kdl;
      "waybar/config".text        = builtins.readFile ./config/waybar-config.json;
      "waybar/style.css".text     = builtins.readFile ./config/waybar-style.css;
    };
  };
}
