{
  flake.modules.nixos.postgresql = {
    services.postgresql.enable = true;
    services.postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 03:15:00";
    };
  };
}
