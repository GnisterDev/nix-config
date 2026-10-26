# System secrets are decrypted with the host's SSH key
# `ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub` to .sops.yaml before encrypting
{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

      environment.systemPackages = with pkgs; [
        sops
        age
        ssh-to-age
      ];

      programs.gnupg.agent.enable = true;
    };

  flake.modules.homeManager.base =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age = {
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        };
      };
    };
}
