# Language servers come from Nix (modules/dev) and
# are only enabled when their executable are on PATH.
{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.editor.neovim;

      # lazy.nvim looks plugins up as <dev.path>/<name>, where <name> is the
      # last component of the spec's repo URL.
      plugins = with pkgs.vimPlugins; {
        "nvim-treesitter" = pkgs.symlinkJoin {
          name = "nvim-treesitter-with-grammars";
          paths = [ nvim-treesitter ] ++ nvim-treesitter.withAllGrammars.dependencies;
        };
        "telescope.nvim" = telescope-nvim;
        "telescope-fzf-native.nvim" = telescope-fzf-native-nvim;
        "plenary.nvim" = plenary-nvim;
        "which-key.nvim" = which-key-nvim;
        "gitsigns.nvim" = gitsigns-nvim;
        "nvim-autopairs" = nvim-autopairs;
        "Comment.nvim" = comment-nvim;
        "mini.nvim" = mini-nvim;
        "nvim-lspconfig" = nvim-lspconfig;
        "blink.cmp" = blink-cmp;
        "friendly-snippets" = friendly-snippets;
        "lazydev.nvim" = lazydev-nvim;
        "conform.nvim" = conform-nvim;
        "nvim-lint" = nvim-lint;
        "lualine.nvim" = lualine-nvim;
        "noice.nvim" = noice-nvim;
        "nui.nvim" = nui-nvim;
        "snacks.nvim" = snacks-nvim;
        "nvim-web-devicons" = nvim-web-devicons;
        "tokyonight.nvim" = tokyonight-nvim;
        "catppuccin" = catppuccin-nvim;
        "rose-pine" = rose-pine;
        "gruvbox.nvim" = gruvbox-nvim;
      };

      pluginDir = pkgs.linkFarm "lazy-plugins" (
        lib.mapAttrsToList (name: path: { inherit name path; }) plugins
      );

      # Values the Lua config reads via `require("nix")`.
      bridge = {
        lazy = "${pkgs.vimPlugins.lazy-nvim}";
        plugins = "${pluginDir}";
        inherit (cfg)
          colorscheme
          palette
          background
          transparent
          ;
      };
    in
    {
      options.editor.neovim = {
        colorscheme = lib.mkOption {
          type = lib.types.str;
          default = "tokyonight-night";
          description = "Colorscheme to load when no base16 `palette` is set.";
        };
        palette = lib.mkOption {
          type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
          default = null;
          description = ''
            base16 palette (`base00` … `base0F`, as "#rrggbb"). When set, Neovim
            paints itself with mini.base16 instead of `colorscheme`. Rice
            profiles set this so the editor follows the desktop.
          '';
        };
        background = lib.mkOption {
          type = lib.types.enum [
            "dark"
            "light"
          ];
          default = "dark";
        };
        transparent = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Leave the editor background to the terminal.";
        };
      };

      config = {
        home.packages = [
          pkgs.neovim
          pkgs.tree-sitter
        ];

        home.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          MANPAGER = "nvim +Man!";
        };

        programs.zsh.shellAliases = {
          vi = "nvim";
          vim = "nvim";
        };

        xdg.configFile = {
          "nvim/init.lua".source = ./nvim/init.lua;
          "nvim/lua/config".source = ./nvim/lua/config;
          "nvim/lua/plugins".source = ./nvim/lua/plugins;
          "nvim/lua/nix.lua".text = "return ${lib.generators.toLua { } bridge}\n";
        };
      };
    };
}
