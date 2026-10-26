{
  flake.modules.homeManager.base = {
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
        cls = "clear";
        ".." = "cd ..";
        "..." = "cd ../..";

        gs = "git status";
        gc = "git commit";
        gp = "git push";
        gpl = "git pull";
        lg = "lazygit";

        nb = "nh os switch";
        nbb = "nh os boot";
        nup = "nh os switch --update";
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$hostname$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
        hostname = {
          ssh_only = true;
          format = "[$hostname]($style) ";
        };
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
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      };
    };
  };
}
