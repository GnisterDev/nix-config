# Photo library at https://photos.<domain>.
{ config, ... }:
let
  inherit (config.constants) domain;
in
{
  flake.modules.nixos.immich = {
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      port = 2283;
    };

    services.caddy.virtualHosts."photos.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:2283
    '';
  };
}
