{ config, ... }:
{
  home-manager.users.${config.systemConstants.username} = {
    programs.btop = {
      enable = true;
      settings = {
        color_theme      = "Default";
        vim_keys         = true;
        rounded_corners  = true;
        update_ms        = 1000;
      };
    };
  };
}
