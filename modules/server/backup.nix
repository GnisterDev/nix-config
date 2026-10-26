# Nightly restic backups. 
# Add secrets to secrets/secrets.yaml (and the server's key to .sops.yaml):
#
#   restic:
#     password: <long random string>
#     repository: sftp:user@host:/backups/server   # or s3:..., b2:..., rest:...
{
  flake.modules.nixos.backup =
    { config, ... }:
    {
      sops.secrets = {
        "restic/password" = { };
        "restic/repository" = { };
      };

      services.restic.backups.daily = {
        initialize = true;
        passwordFile = config.sops.secrets."restic/password".path;
        repositoryFile = config.sops.secrets."restic/repository".path;
        paths = [
          "/home"
          "/srv"
          "/var/lib"
          "/var/backup"
        ];
        exclude = [
          "/var/lib/postgresql"
          "/var/lib/containers"
          "/home/*/.cache"
        ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
        ];
      };
    };
}
