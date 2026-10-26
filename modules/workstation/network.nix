{ config, ... }:
{
  flake.modules.nixos.workstation = {
    networking.networkmanager.enable = true;
    users.users.${config.constants.user.username}.extraGroups = [ "networkmanager" ];

    # Tray applet + nm-connection-editor.
    programs.nm-applet = {
      enable = true;
      indicator = true;
    };
  };
}
