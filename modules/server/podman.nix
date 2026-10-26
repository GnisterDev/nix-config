{
  flake.modules.nixos.server =
    { pkgs, ... }:
    {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
          autoPrune.enable = true;
        };
        oci-containers.backend = "podman";
      };

      environment.systemPackages = [ pkgs.podman-compose ];
    };
}
