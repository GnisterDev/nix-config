{ config, pkgs, ... }:
{
  programs.fish.enable = true;

  users.defaultUserShell = pkgs.fish;

  home-manager.users.${config.systemConstants.username} = {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[>](bold green)";
          error_symbol   = "[>](bold red)";
        };
      };
    };
  };
}
