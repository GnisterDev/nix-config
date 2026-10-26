# Media server at https://jellyfin.<domain>, with GPU transcoding access.
{ config, ... }:
let
  inherit (config.constants) domain;
in
{
  flake.modules.nixos.jellyfin = {
    services.jellyfin.enable = true;
    users.users.jellyfin.extraGroups = [
      "video"
      "render"
    ];
    hardware.graphics.enable = true;

    services.caddy.virtualHosts."jellyfin.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
  };
}
