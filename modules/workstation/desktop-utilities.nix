{
  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      programs = {
        yazi.enable = true; # terminal file manager
        imv.enable = true; # images
        mpv.enable = true; # video / audio
        zathura.enable = true; # PDF / documents
      };

      home.packages = with pkgs; [
        keepassxc
        file-roller
        networkmanagerapplet # nm-connection-editor
      ];
    };
}
