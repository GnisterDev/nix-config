# Non-Steam games: Lutris, Heroic (Epic / GOG / Amazon) and plain Wine.
{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
         lutris                         # open-source game platform / launcher
         heroic                         # Epic Games, GOG & Amazon Prime launcher
         wineWow64Packages.stagingFull  # Windows API compatibility layer
         winetricks                     # helper script to install Wine dependencies
      ];
    };
}
