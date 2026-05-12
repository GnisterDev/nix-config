{ config, pkgs, ... }:
{
  wsl = {
    enable             = true;
    defaultUser        = "gnister";
    startMenuLaunchers = true;
  };

  programs.nix-ld.enable = true;

  networking.hostName = "wsl";

  system.stateVersion = "25.05";
}