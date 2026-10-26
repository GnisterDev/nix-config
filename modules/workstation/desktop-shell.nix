{
  flake.modules.homeManager.workstation =
    { config, lib, ... }:
    let
      lock = "${lib.getExe config.programs.swaylock.package} -f";
    in
    {
      programs.foot = {
        enable = true;
        settings = {
          main.term = "xterm-256color";
          mouse.hide-when-typing = "yes";
          scrollback.lines = 10000;
          cursor.style = lib.mkDefault "beam";
        };
      };

      programs.fuzzel = {
        enable = true;
        settings.main = {
          terminal = "foot -e";
          layer = "overlay";
          lines = 12;
          width = 40;
          horizontal-pad = 20;
          vertical-pad = 12;
          inner-pad = 8;
        };
      };

      services.mako = {
        enable = true;
        settings = {
          default-timeout = 6000;
          anchor = "top-right";
          layer = "overlay";
          max-visible = 5;
          padding = "12";
          margin = "12";
        };
      };

      programs.wlogout = {
        enable = true;
        layout = [
          {
            label = "lock";
            action = lock;
            text = "Lock";
            keybind = "l";
          }
          {
            label = "logout";
            action = "niri msg action quit --skip-confirmation";
            text = "Log out";
            keybind = "e";
          }
          {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "u";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
          }
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shut down";
            keybind = "s";
          }
        ];
      };
    };
}
