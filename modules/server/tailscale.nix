{ config, ... }:
{
  flake.modules.nixos.tailscale =
    { lib, ... }:
    {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = lib.mkDefault "client";
      };
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
    };

  flake.modules.nixos.server = {
    imports = [ config.flake.modules.nixos.tailscale ];
    services.tailscale.useRoutingFeatures = "server";
  };
}
