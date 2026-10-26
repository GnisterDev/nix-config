{
  flake.modules.nixos.server =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        tcpdump
        mtr
        iperf3
        dig
        restic
      ];
    };
}
