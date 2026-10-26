# A private SMB share at \\server\share (/srv/share), discoverable from Windows.
# SMB password: sudo smbpasswd -a <user>
{ config, ... }:
let
  inherit (config.constants.user) username;
in
{
  flake.modules.nixos.samba = {
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server string" = "server";
          security = "user";
          "map to guest" = "never";
          # LAN and tailnet only.
          "hosts allow" = "192.168. 10. 100. 127.";
          "hosts deny" = "ALL";
        };
        share = {
          path = "/srv/share";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "valid users" = username;
          "create mask" = "0664";
          "directory mask" = "0775";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    systemd.tmpfiles.rules = [ "d /srv/share 0775 ${username} users -" ];
  };
}
