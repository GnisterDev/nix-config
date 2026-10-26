{
  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libreoffice
        hunspell
        hunspellDicts.nb_NO
        hunspellDicts.nn_NO
        hunspellDicts.en_US-large

        thunderbird
        obsidian

        signal-desktop
        element-desktop

        vesktop
        teams-for-linux
        # zoom-us
      ];
    };
}
