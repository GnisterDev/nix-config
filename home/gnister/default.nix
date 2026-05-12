{ config, pkgs, lib, isDesktop ? false, ... }:
{
  imports = [ ./niri.nix ];

  home.username    = "gnister";
  home.homeDirectory = "/home/gnister";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # Git
  programs.git = {
    enable    = true;
    name  = "gnister";
    email = "sscharer@online.no";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase        = false;
      push.autoSetupRemote = true;
    };
  };

  # Shell
  programs.bash = {
    enable = true;
    shellAliases = {
      cls = "clear";
      ll  = "ls -lah";
    };
    initExtra = ''
      # Put any extra shell init here
    '';
  };
  
  # Terminal — Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding    = { x = 12; y = 12; };
        decorations = "None";
      };
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold   = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        size   = 13.0;
      };
      colors = {
        # Catppuccin Mocha palette — change to taste
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };

  # Fuzzel launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font           = "JetBrainsMono Nerd Font:size=12";
        terminal       = "alacritty -e";
        width          = 40;
        lines          = 10;
        prompt         = ''"❯ "'';
      };
    };
  };

  # Mako notifications
  services.mako = {
    enable            = true;
    defaultTimeout    = 5000;
    backgroundColor   = "#1e1e2edd";
    textColor         = "#cdd6f4";
    borderColor       = "#89b4fa";
    borderRadius      = 8;
    borderSize        = 2;
  };

  # Waybar
  programs.waybar = {
    enable  = true;
    systemd.enable = true;   # Start with the graphical session
    settings = [{
      layer    = "top";
      position = "top";
      height   = 30;
      modules-left   = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right  = [ "pulseaudio" "network" "battery" "tray" ];

      clock = {
        format    = " {:%H:%M  %d %b}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      battery = {
        states    = { warning = 30; critical = 15; };
        format    = "{icon} {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };

      network = {
        format-wifi         = "  {signalStrength}%";
        format-ethernet     = "󰈀 ";
        format-disconnected = "󰖪 ";
        tooltip-format      = "{essid} ({signalStrength}%)";
      };

      pulseaudio = {
        format        = "{icon} {volume}%";
        format-muted  = "󰝟 ";
        format-icons  = { default = [ "" "" "" ]; };
        on-click      = "pavucontrol";
      };
    }];
  };

  # XDG user directories
  xdg.userDirs = {
    enable      = true;
    createDirectories = true;
  };
}
