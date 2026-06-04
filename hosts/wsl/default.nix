{ inputs, lib, ... }:
let
  hostname = "wsl";
  username = inputs.self.constants.user.username;
  system = inputs.self.constants.system;
in
{
  flake.modules.nixos.${hostname} = { pkgs, ... }: 
  {
    imports = with inputs.self.modules.nixos; [
      common git nh shell btop
      secrets
    ];

    home-manager = {
      useGlobalPkgs   = true;
      useUserPackages = true;

      users.gnister = {
        imports = with inputs.self.modules.homeManager; [
          # lazygit
        ];
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion  = system.version;
        };
      };
    };

    programs.nix-ld.enable = true;

    wsl = {
      enable      = true;
      defaultUser = username;
    };

    networking.hostName = hostname;

    users.users.${username} = {
      isNormalUser = true;
      extraGroups  = [ "wheel" ];
    };

    system.stateVersion = system.version;
  };
  
  flake.nixosConfigurations = inputs.self.lib.mkWsl "x86_64-linux" hostname;
}
