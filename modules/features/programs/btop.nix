{ inputs, ... }:
{
  flake.modules.nixos.btop = {pkgs, ...}: {
    environment.systemPackages = [ pkgs.btop ];
  };

  flake.modules.homeManager.btop = { pkgs, ... }: {
    programs.btop = {
      enable   = true;
      settings = {
        color_theme = "onedark";
        theme_background = false;
        truecolor = true;
        vim_keys = true;
        graph_symbol = "braille";
        update_ms = 200;
        proc_sorting = "cpu lazy";
        proc_cpu_graphs = false;
        cpu_single_graph = true;
        show_coretemp = false;
        io_mode = true;
      };
    };
  };
}
