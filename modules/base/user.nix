{ config, ... }:
let
  inherit (config.constants) user;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      users.users.${user.username} = {
        isNormalUser = true;
        description = user.name;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = user.sshKeys;
      };

      programs.zsh.enable = true;
      # Lets home-manager's zsh find completions for system packages.
      environment.pathsToLink = [ "/share/zsh" ];
    };
}
