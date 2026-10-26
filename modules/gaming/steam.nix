{ config, ... }:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      programs.gamemode.enable = true;
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };


      services.joycond.enable = true;
      
      users.users.${config.constants.user.username}.extraGroups = [ "gamemode" ];
    };

  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      programs.mangohud.enable = true;

      home.packages = with pkgs; [
        steam-run
        protonup-qt
      ];
    };
}
