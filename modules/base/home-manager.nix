{ config, inputs, ... }:
let
  inherit (config.constants.user) username;
in
{
  flake.modules.nixos.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      users.${username} = { };
    };
  };

  flake.modules.homeManager.base =
    { lib, osConfig, ... }:
    {
      home.stateVersion = lib.mkDefault osConfig.system.stateVersion;
      xdg.enable = true;
    };
}
