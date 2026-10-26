{
  flake.modules.homeManager.base = {
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 10;
      historyLimit = 50000;
      terminal = "tmux-256color";
      extraConfig = ''
        set -as terminal-features ",*:RGB"
        set -g renumber-windows on
        set -g set-clipboard on

        # Splits and new windows keep the current directory.
        bind '"' split-window -v -c "#{pane_current_path}"
        bind %   split-window -h -c "#{pane_current_path}"
        bind c   new-window      -c "#{pane_current_path}"

        # hjkl pane movement.
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
      '';
    };
  };
}
