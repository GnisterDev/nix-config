# Service modules add their own `services.caddy.virtualHosts."<name>.${domain}"`.
# Caddy signs certificates with its own local CA.
{
  flake.modules.nixos.server = {
    services.caddy = {
      enable = true;
      globalConfig = ''
        local_certs
      '';
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
