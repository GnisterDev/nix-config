{ inputs, pkgs, ... }:
{
  flake.modules.nixos.wsl = {
    imports = with inputs.self.modules.nixos; [
      base
      cli
    ];

    networking.hostName = "laptop";
    programs.nix-ld.enable = true;

    users.users.gnister = {
      isNormalUser = true;
      description  = "gnister";
      extraGroups  = [ "wheel" ];
    };

    home-manager.users.gnister = {
      # imports = [ inputs.self.modules.homeManager.wsl ];
      systemd.user.startServices = false;
      home.stateVersion = "25.05";
    };

    networking.hosts = { };
    system.stateVersion = "25.05";
  };
}