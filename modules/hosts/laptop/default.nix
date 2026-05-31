{ inputs, lib, ... }:
let
  hostname = "laptop";
  username = inputs.self.constants.user.username;
  system = inputs.self.constants.system;
in
{
  flake.modules.nixos.${hostname} = { pkgs, ... }:
  {
    imports = with inputs.self.modules.nixos; [
      git nh bootloader
    ];

    home-manager = {
      useGlobalPkgs   = true;
      useUserPackages = true;

      users.gnister = {
        imports = with inputs.self.modules.homeManager; [
          # lazygit
        ];
        home.username      = username;
        home.homeDirectory = "/home/${username}";
        home.stateVersion  = system.version;
      };
    };

    networking = {
      hostName = hostname;
      networkmanager.enable = true;
    };

    users.users.${username} = {
      isNormalUser = true;
      extraGroups  = [ "wheel" "networkmanager" "video" "audio" ];
    };

    time.timeZone      = system.timeZone;
    i18n.defaultLocale = system.defaultLocale;
    i18n.extraLocaleSettings.LC_TIME = system.extraLocales.LC_TIME;

    services.fwupd.enable = true;

    hardware.bluetooth = {
      enable      = true;
      powerOnBoot = false;
    };
    services.blueman.enable = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    system.stateVersion = system.version;
  };

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" hostname;
}
