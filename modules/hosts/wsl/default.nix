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
      git nh
    ];

    home-manager = {
      useGlobalPkgs   = true;
      useUserPackages = true;

      users.gnister = {
        imports = with inputs.self.modules.homeManager; [
          # lazygit
        ];
        home.username      = username;
        home.homeDirectory = "/home/${username}";
        home.stateVersion  = system.version;
      };
    };

    nix.settings.experimental-features = "nix-command flakes";

    wsl = {
      enable      = true;
      defaultUser = username;
    };

    networking.hostName = hostname;

    users.users.${username} = {
      isNormalUser = true;
      extraGroups  = [ "wheel" ];
    };

    time.timeZone      = system.timeZone;
    i18n.defaultLocale = system.defaultLocale;
    system.stateVersion = system.version;
  };
  
  flake.nixosConfigurations = inputs.self.lib.mkWsl "x86_64-linux" hostname;
}
