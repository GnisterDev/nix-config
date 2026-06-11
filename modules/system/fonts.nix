_:
{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.noto

        noto-fonts                 # broad Unicode coverage
        noto-fonts-cjk-sans        # Chinese / Japanese / Korean

        liberation_ttf             # Arial, Times New Roman, Courier New
        inter
      ];

      fontconfig = {
        defaultFonts = {
          serif      = [ "Noto Serif" "Liberation Serif" ];
          sansSerif  = [ "Inter" "Noto Sans" "Liberation Sans" ];
          monospace  = [ "FiraCode Nerd Font" "JetBrainsMono Nerd Font" ];
          emoji      = [ "Noto Color Emoji" ];
        };

        antialias    = true;
        hinting = {
          enable = true;
          style  = "slight";
        };
        subpixel = {
          rgba  = "rgb"; # bgr if colours look fringed
          lcdfilter = "default";
        };
      };
    };
  };
}
