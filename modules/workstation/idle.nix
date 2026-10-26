# Lock and idle handling: swaylock(-effects) and swayidle. Hosts tune the
# timings through `workstation.idle` (the laptop suspends, the desktop doesn't).
# The lock screen's look comes from the rice profile.
{
  flake.modules.nixos.workstation =
    { lib, ... }:
    {
      options.workstation.idle = {
        lockAfter = lib.mkOption {
          type = lib.types.ints.positive;
          default = 600;
          description = "Seconds of inactivity before the screen locks.";
        };
        screenOffAfter = lib.mkOption {
          type = lib.types.ints.positive;
          default = 900;
          description = "Seconds of inactivity before monitors power off.";
        };
        suspendAfter = lib.mkOption {
          type = lib.types.nullOr lib.types.ints.positive;
          default = null;
          description = "Seconds of inactivity before suspending, or null to never suspend.";
        };
      };

      config.security.pam.services.swaylock = { };
    };

  flake.modules.homeManager.workstation =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      idle = osConfig.workstation.idle;
      lock = "${lib.getExe config.programs.swaylock.package} -f";
      niri = lib.getExe osConfig.programs.niri.package;
    in
    {
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          clock = true;
          indicator = true;
          indicator-radius = 110;
          indicator-thickness = 8;
          show-failed-attempts = true;
          ignore-empty-password = true;
          fade-in = 0.2;
        };
      };

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = idle.lockAfter;
            command = lock;
          }
          {
            timeout = idle.screenOffAfter;
            command = "${niri} msg action power-off-monitors";
          }
        ]
        ++ lib.optional (idle.suspendAfter != null) {
          timeout = idle.suspendAfter;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        };
        events = {
          before-sleep = lock;
          inherit lock;
        };
      };
    };
}
