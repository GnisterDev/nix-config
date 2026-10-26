{
  flake.modules.nixos.creative = {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };

  flake.modules.homeManager.creative =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        blender
        krita
        gimp3
        inkscape
        kdePackages.kdenlive
        audacity
        ffmpeg
        imagemagick
      ];
    };
}
