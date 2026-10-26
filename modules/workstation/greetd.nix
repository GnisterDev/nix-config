{
  flake.modules.nixos.workstation =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
          user = "greeter";
        };
      };

      # Keep boot messages from scribbling over the greeter.
      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
}
