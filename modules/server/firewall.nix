{
  flake.modules.nixos.server = {
    networking.nftables.enable = true;
    networking.firewall.enable = true;
  };
}
