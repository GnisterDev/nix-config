{ config, ... }:
{
  configurations.nixos.wsl.module = {
    imports = with config.flake.modules.nixos; [
      base
      dev
      wsl
    ];

    # "true" when Docker Desktop's "WSL integration" is enabled
    wsl.docker-desktop.enable = false;
    system.stateVersion = "26.05";
  };
}
