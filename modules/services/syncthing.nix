# File sync as the main user.
# Devices and folders are managed in the web UI.
# SSH tunnel: ssh -L 8384:127.0.0.1:8384 server
{ config, ... }:
let
  inherit (config.constants.user) username;
in
{
  flake.modules.nixos.syncthing = {
    services.syncthing = {
      enable = true;
      user = username;
      group = "users";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
      openDefaultPorts = true;
      guiAddress = "127.0.0.1:8384";
      overrideDevices = false;
      overrideFolders = false;
    };
  };
}
