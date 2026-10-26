{
  flake.modules.homeManager.workstation = {
    programs.firefox = {
      enable = true;
      languagePacks = [
        "en-GB"
        "en-US"
        "nb-NO"
      ];
      profiles.default = {
        id = 0;
        isDefault = true;
      };
    };

    programs.chromium.enable = true;
  };
}
