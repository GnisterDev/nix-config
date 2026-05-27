{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.lazygit ];

  home-manager.users.${config.systemConstants.username} = {
    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          lightTheme              = false;
          activeBorderColor       = [ "blue" "bold" ];
          inactiveBorderColor     = [ "white" ];
          selectedLineBgColor     = [ "blue" ];
        };
      };
    };
  };
}
