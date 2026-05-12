{ config, pkgs, ... }:
{
  # Niri — Wayland compositor / window manager
  programs.niri.enable = true;
  programs.xwayland.enable = true;  # Compatibility for X11 apps

  # Login manager — greetd + tuigreet (minimal TUI greeter)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user    = "greeter";
      };
    };
  };

  # Suppress the "failed units" message on the greeter
  systemd.services.greetd.serviceConfig.SuppressOutput = true;

  # Audio — PipeWire
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;  # PulseAudio compatibility
    jack.enable       = false;
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  # Bluetooth
  hardware.bluetooth = {
    enable       = true;
    powerOnBoot  = true;
  };
  services.blueman.enable = true;

  # Networking (WiFi + wired via NetworkManager)
  networking.networkmanager.enable = true;

  # XDG portals (file pickers, screen share, etc.)
  xdg.portal = {
    enable        = true;
    extraPortals  = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  # Polkit — needed for GUI apps to request elevated privileges
  security.polkit.enable = true;

  systemd.user.services.polkit-gnome = {
    description = "GNOME Polkit authentication agent";
    wantedBy    = [ "graphical-session.target" ];
    wants       = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig = {
      Type      = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart   = "on-failure";
    };
  };

  
  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # Wayland / graphical packages
  environment.systemPackages = with pkgs; [
    # Screenshot (Wayland-native)
    grim          # Grab screenshots
    slurp         # Select screen region
    wl-clipboard  # wl-copy / wl-paste

    # App launcher
    fuzzel

    # Terminal
    alacritty

    # Notification daemon
    mako

    # Status bar
    waybar

    # Network applet for system tray
    networkmanagerapplet

    # Bluetooth GUI
    blueman

    # GTK theming helper
    gsettings-desktop-schemas
    adwaita-icon-theme
  ];

  # Dconf — needed for GTK apps to save settings
  programs.dconf.enable = true;
}
