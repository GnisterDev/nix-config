{ inputs, ... }:
{
  flake.modules.nixos.shell = { pkgs, ... }: {
    programs.zsh.enable = true;

    users.users.${inputs.self.constants.user.username} = {
      shell = pkgs.zsh;
    };

    environment.systemPackages = with pkgs; [
      zsh
    ];

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.shell
    ];
  };

  flake.modules.homeManager.shell = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        share = true;
      };

      shellAliases = {
        ls  = "ls --color=auto";
        ll  = "ls -lah";
        la  = "ls -A";
        ".." = "cd ..";
        "..." = "cd ../..";
        gs  = "git status";
        gc  = "git commit";
        gp  = "git push";
        gpl = "git pull";
        nb  = "nh os switch";
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
        git_branch.symbol = " ";
        git_status.format = "([$all_status$ahead_behind]($style) )";
        nix_shell = {
          symbol = " ";
          format = "[$symbol$name]($style) ";
        };
        cmd_duration = {
          min_time = 2000;
          format = "[$duration]($style) ";
        };
        character = {
          success_symbol = "[❯](green)";
          error_symbol   = "[❯](red)";
        };
      };
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}