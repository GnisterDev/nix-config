{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        wget
        rsync
        zip
        unzip
        gnutar
        tree
        file
        which
        lsof
        strace
        openssl
        htop
        ncdu
        jq
        yq-go
        man-pages
        man-pages-posix
      ];

      documentation.man.enable = true;
    };

  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        ripgrep
        fd
      ];

      programs = {
        bat = {
          enable = true;
          # Rice profiles (stylix) replace the theme on workstations.
          config.theme = lib.mkDefault "TwoDark";
        };
        eza = {
          enable = true;
          icons = "auto";
          git = true;
          extraOptions = [ "--group-directories-first" ];
        };
        fzf = {
          enable = true;
          defaultCommand = "fd --type f --hidden --exclude .git";
          fileWidget.command = "fd --type f --hidden --exclude .git";
          changeDirWidget.command = "fd --type d --hidden --exclude .git";
        };
        zoxide.enable = true;
        man.enable = true;
      };
    };
}
