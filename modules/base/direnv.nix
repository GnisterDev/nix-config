# Per-project environments
# - `use flake` in an .envrc, cached by nix-direnv
{
  flake.modules.homeManager.base = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global = {
        hide_env_diff = true;
        warn_timeout = "30s";
      };
    };
  };
}
