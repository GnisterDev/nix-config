# Self-hosted git at https://git.<domain>, backed by PostgreSQL.
# Registration is closed; create the first admin with:
#   sudo -u forgejo forgejo admin user create --admin --username <you> --email <mail> \
#     --random-password --config /var/lib/forgejo/custom/conf/app.ini
{ config, ... }:
let
  inherit (config.constants) domain;
in
{
  flake.modules.nixos.forgejo = {
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.${domain}";
          ROOT_URL = "https://git.${domain}/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 3001;
        };
        service.DISABLE_REGISTRATION = true;
        session.COOKIE_SECURE = true;
      };
    };

    services.caddy.virtualHosts."git.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:3001
    '';
  };
}
