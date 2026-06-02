{ inputs, ... }:
{
  flake.modules.nixos.git = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.git ];
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.git
    ];
  };

  flake.modules.homeManager.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = inputs.self.constants.user.username;
          email = inputs.self.constants.user.email;
        };

        init.defaultBranch = "main";
        pull.rebase         = true;
        push.autoSetupRemote = true;
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate     = true;
          line-numbers = true;
          side-by-side = true;
        };
        merge.conflictstyle = "diff3";
        diff.colorMoved     = "default";
      };
    };
    home.packages = [ pkgs.delta ];
  };
}
