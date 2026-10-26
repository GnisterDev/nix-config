{ config, inputs, ... }:
let
  inherit (config.constants.user) username;
in
{
  flake.modules.nixos.wsl = {
    imports = [ inputs.nixos-wsl.nixosModules.default ];

    wsl = {
      enable = true;
      defaultUser = username;
      startMenuLaunchers = true;

      ssh-agent.enable = true;
    };
  };

  flake.modules.homeManager.wsl = {
    home.sessionVariables.BROWSER = "explorer.exe";
  };
}
