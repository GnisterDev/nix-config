{ inputs, ... }:
{
  flake.modules.nixos.secrets = { pkgs, lib, config, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    environment.systemPackages = with pkgs; [
      sops age ssh-to-age gnupg
    ];

    # Default secrets file — every host that imports this module will look
    # here.  Individual secrets are declared wherever they are needed, e.g.:
    #
    #   sops.secrets."wireguard/privateKey" = {
    #     owner = "systemd-network";
    #   };
    #
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      };
    };

    services.openssh = {
      enable = true;
      hostKeys = [
        { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }
      ];
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.secrets
    ];
  };

  flake.modules.homeManager.secrets = { pkgs, lib, config, ... }: {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    home.packages = with pkgs; [
      sops age ssh-to-age
    ];

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age = {
        keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      };

      # secrets."github/token" = {};
    };
  };
}