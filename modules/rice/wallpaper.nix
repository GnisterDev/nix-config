{
  flake.modules.homeManager.workstation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.rice;
      p = cfg.current;
      awww = lib.getExe config.services.awww.package;

      generate =
        kind: colors:
        let
          c = i: lib.escapeShellArg (lib.elemAt colors (lib.min i (lib.length colors - 1)));
          grain = "-attenuate 0.12 +noise Gaussian";
          scripts = {
            solid = ''magick -size 3840x2160 xc:${c 0} "$out"'';
            gradient = ''magick -size 3840x2160 -define gradient:angle=135 gradient:${c 0}-${c 1} ${grain} "$out"'';
            radial = ''magick -size 3840x2160 radial-gradient:${c 1}-${c 0} ${grain} "$out"'';
            blobs = ''
              magick -size 960x540 xc:${c 0} \
                -fill ${c 1}90 -draw "circle 170,450 170,660" \
                -fill ${c 2}80 -draw "circle 800,110 800,300" \
                -fill ${c 3}50 -draw "circle 580,560 580,690" \
                -blur 0x80 -resize '3840x2160!' ${grain} "$out"
            '';
          };
        in
        pkgs.runCommandLocal "wallpaper-${cfg.active}.png" {
          nativeBuildInputs = [ pkgs.imagemagick ];
        } scripts.${kind};

      wallpaper =
        if p.wallpaper.image != null then
          p.wallpaper.image
        else if p.scheme == null then
          throw "rice profile \"${cfg.active}\": set `scheme`, or give a `wallpaper.image` to derive the palette from."
        else
          generate p.wallpaper.generate (
            map (s: config.lib.stylix.colors.withHashtag.${s}) p.wallpaper.colors
          );
    in
    {
      options.rice.wallpaper = lib.mkOption {
        type = lib.types.path;
        readOnly = true;
        internal = true;
      };

      config = {
        rice.wallpaper = wallpaper;

        services.awww.enable = true;

        systemd.user.services.rice-wallpaper = {
          Unit = {
            Description = "Paint the rice profile's wallpaper";
            Requires = [ "awww.service" ];
            After = [ "awww.service" ];
            PartOf = [ "graphical-session.target" ];
            X-Restart-Triggers = [ "${wallpaper}" ];
          };
          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = toString (
              pkgs.writeShellScript "rice-wallpaper" ''
                for _ in $(${pkgs.coreutils}/bin/seq 50); do
                  ${awww} query >/dev/null 2>&1 && break
                  ${pkgs.coreutils}/bin/sleep 0.1
                done
                exec ${awww} img \
                  --transition-type ${lib.escapeShellArg p.wallpaper.transition} \
                  --transition-fps 60 --transition-duration 1.2 \
                  ${wallpaper}
              ''
            );
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
