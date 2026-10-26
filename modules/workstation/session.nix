# Background pieces of a desktop session: privilege prompts, removable
# drives, trash/MTP, battery and power-profile information for the bar.
{
  flake.modules.nixos.workstation = {
    security.polkit.enable = true;
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
      upower.enable = true;
      # Balanced / power-saver / performance, switchable from the bar.
      power-profiles-daemon.enable = true;
    };
    programs.dconf.enable = true;
  };

  flake.modules.homeManager.workstation = {
    services.polkit-gnome.enable = true;

    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
    };
  };
}
