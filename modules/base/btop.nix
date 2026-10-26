{ lib, ... }:
{
  flake.modules.homeManager.base = {
    programs.btop = {
      enable = true;
      settings = {
        # Rice profiles (stylix) replace the theme on workstations.
        color_theme = lib.mkDefault "onedark";
        theme_background = lib.mkDefault false;
        truecolor = true;
        vim_keys = true;
        graph_symbol = "braille";
        update_ms = 500;
        proc_sorting = "cpu lazy";
        proc_cpu_graphs = false;
        cpu_single_graph = true;
        show_coretemp = true;
        io_mode = true;
      };
    };
  };
}
