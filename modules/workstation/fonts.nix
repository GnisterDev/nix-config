{
  flake.modules.nixos.workstation =
    { pkgs, ... }:
    {
      fonts = {
        enableDefaultPackages = true;

        packages = with pkgs; [
          nerd-fonts.fira-code
          nerd-fonts.jetbrains-mono
          nerd-fonts.symbols-only

          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji

          liberation_ttf # Arial / Times New Roman / Courier New metrics
          inter
        ];

        fontconfig = {
          defaultFonts = {
            serif = [
              "Noto Serif"
              "Liberation Serif"
            ];
            sansSerif = [
              "Inter"
              "Noto Sans"
              "Liberation Sans"
            ];
            monospace = [
              "FiraCode Nerd Font"
              "JetBrainsMono Nerd Font"
            ];
            emoji = [ "Noto Color Emoji" ];
          };
          antialias = true;
          hinting = {
            enable = true;
            style = "slight";
          };
          subpixel = {
            rgba = "rgb";
            lcdfilter = "default";
          };
        };
      };
    };
}
