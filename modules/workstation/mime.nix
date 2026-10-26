{
  flake.modules.homeManager.workstation =
    { lib, ... }:
    let
      associate = app: types: lib.genAttrs types (_: app);
    in
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          associate "firefox.desktop" [
            "text/html"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ]
          // associate "org.pwmt.zathura.desktop" [ "application/pdf" ]
          // associate "imv.desktop" [
            "image/png"
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/svg+xml"
          ]
          // associate "mpv.desktop" [
            "video/mp4"
            "video/x-matroska"
            "video/webm"
            "audio/mpeg"
            "audio/flac"
          ]
          // associate "org.gnome.FileRoller.desktop" [
            "application/zip"
            "application/x-tar"
            "application/x-7z-compressed"
          ];
      };
    };
}
