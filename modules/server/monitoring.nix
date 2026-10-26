{ config, ... }:
let
  inherit (config.constants) domain;
in
{
  flake.modules.nixos.server =
    { config, pkgs, ... }:
    let
      prometheus = config.services.prometheus;
      secretKey = "/var/lib/grafana/secret_key";
    in
    {
      systemd.services.grafana-secret-key = {
        description = "Generate Grafana's secret key";
        wantedBy = [ "grafana.service" ];
        before = [ "grafana.service" ];
        serviceConfig.Type = "oneshot";
        script = ''
          if [ ! -s ${secretKey} ]; then
            install -d -m 700 -o grafana -g grafana /var/lib/grafana
            (umask 077 && ${pkgs.openssl}/bin/openssl rand -hex 32 > ${secretKey})
            chown grafana:grafana ${secretKey}
          fi
        '';
      };

      services.prometheus = {
        enable = true;
        listenAddress = "127.0.0.1";
        retentionTime = "30d";
        exporters.node = {
          enable = true;
          listenAddress = "127.0.0.1";
          enabledCollectors = [ "systemd" ];
        };
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              { targets = [ "127.0.0.1:${toString prometheus.exporters.node.port}" ]; }
            ];
          }
        ];
      };

      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 3000;
            domain = "grafana.${domain}";
            root_url = "https://grafana.${domain}/";
          };
          security.secret_key = "$__file{${secretKey}}";
          analytics.reporting_enabled = false;
        };
        provision.datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString prometheus.port}";
            isDefault = true;
          }
        ];
      };

      services.caddy.virtualHosts."grafana.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:3000
      '';
    };
}
