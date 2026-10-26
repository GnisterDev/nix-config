{ config, ... }:
{
  configurations.nixos.server.module = {
    imports =
      (with config.flake.modules.nixos; [
        base
        metal
        server

        postgresql
        jellyfin
        syncthing
        forgejo
        immich
        samba
        # backup  # restic; add its secrets first, see modules/server/backup.nix
      ])
      ++ [ ./_hardware.nix ];

    boot.loader.grub.useOSProber = false;

    system.stateVersion = "26.05";
  };
}
