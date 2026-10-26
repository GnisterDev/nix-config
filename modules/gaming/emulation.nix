# Optional gaming extras. Not imported by any host yet: add `emulation` to a
# host's imports when you actually want them (and drop what you don't).
{
  flake.modules.homeManager.emulation =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        itch
        steamcmd

        retroarch   # NES, SNES, Genesis, Arcade, etc
        dolphin-emu # Nintendo GameCube / Wii
        pcsx2       # PlayStation 2
        rpcs3       # PlayStation 3
        ppsspp      # PSP

        vkbasalt    # Vulkan post-processing FX layer
        goverlay    # GUI overlay configurator for MangoHud / vkBasalt
      ];
    };
}
