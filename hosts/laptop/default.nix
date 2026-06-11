{ inputs, lib, ... }:
let
  hostname = "laptop";
  username = inputs.self.constants.user.username;
  system = inputs.self.constants.system;
in
{
  flake.modules.nixos.${hostname} = { pkgs, ... }:
  {
    imports = with inputs.self.modules.nixos; [
      bootloader
      common git nh shell btop

      secrets
      
      niri alacritty firefox libreoffice
    ] ++ [ ./_filesystem.nix ];

    home-manager = {
      useGlobalPkgs   = true;
      useUserPackages = true;

      users.gnister = {
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion  = system.version;
        };
      };
    };

    networking = {
      hostName = hostname;
      networkmanager.enable = true;
    };

    users.users.${username} = {
      isNormalUser = true;
      extraGroups  = [ "wheel" "networkmanager" "video" "audio" ];
    };

    services.fwupd.enable = true;

    hardware.bluetooth = {
      enable      = true;
      powerOnBoot = false;
    };
    
    services.blueman.enable = true;

    system.stateVersion = system.version;
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" hostname;
} 
