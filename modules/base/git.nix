{ config, ... }:
let
  inherit (config.constants) user;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      # System-wide so root (and nixos-rebuild of a flake) always has git.
      environment.systemPackages = [ pkgs.git ];
    };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            inherit (user) name email;
          };
          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          rerere.enabled = true;
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
          delta = {
            navigate = true;
            line-numbers = true;
            side-by-side = true;
          };
          merge.conflictstyle = "zdiff3";
          diff.colorMoved = "default";
        };
      };

      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };

      programs.lazygit.enable = true;

      home.packages = [ pkgs.delta ];
    };
}
