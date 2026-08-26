_:
{
  flake.lib.checkKDLDir = pkgs: configDir: entry:
    pkgs.runCommand "niri-config-checked"
      {
        nativeBuildInputs = [ pkgs.niri ];
      }
      ''
        mkdir -p $out
        cp -r ${configDir}/. $out/
        niri validate --config $out/${entry}
      '';
}