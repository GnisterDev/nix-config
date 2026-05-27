{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.git ];

  home-manager.users.${config.systemConstants.username} = {
    programs.git = {
      enable = true;
      
      settings = {
        user = {
          name  = config.systemConstants.gitName;
          email = config.systemConstants.gitEmail;
        };
        alias = {
          s   = "status -sb";
          l   = "log --oneline --graph --decorate --all";
          ll  = "log --oneline --graph --decorate";
          co  = "checkout";
          sw  = "switch";
          cp  = "cherry-pick";
          rb  = "rebase";
          new = "checkout -B";
          undo = "reset HEAD~1 --mixed";
          pushf = "push --force-with-lease";
        };

        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        # merge.ff = "only"; 
        # color.ui = true;
        # diff.algorithm = "histogram";
        # credential.helper = "store";
      };

      ignores = [
        ".direnv/"
        ".envrc"
        "*.sw[po]"
        ".DS_Store"
      ];
    };
  };
}
