{ config, ... }:
{
  flake.modules.nixos.workstation = {
    # Backlight access for brightnessctl outside a logind session
    users.users.${config.constants.user.username}.extraGroups = [ "video" ];
  };

  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wl-clipboard
        grim
        slurp
        playerctl
        brightnessctl
        libnotify
      ];

      services.cliphist = {
        enable = true;
        allowImages = true;
      };
    };
}
