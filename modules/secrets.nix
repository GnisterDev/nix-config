{ config, pkgs, lib, ... }:
{
  
  # sops-nix — secrets management
  #
  # FIRST-TIME SETUP:
  # -----------------
  # 1. Generate an age key (once per machine):
  #      mkdir -p ~/.config/sops/age
  #      age-keygen -o ~/.config/sops/age/keys.txt
  #      cat ~/.config/sops/age/keys.txt   # copy the "public key:" line
  #
  # 2. Add the public key to .sops.yaml in this repo.
  #
  # 3. Create a secrets file (example):
  #      sops secrets/common.yaml
  #    Add entries like:
  #      my_password: "hunter2"
  #
  # 4. Reference a secret in any NixOS module:
  #      sops.secrets.my_password = {
  #        sopsFile = ./secrets/common.yaml;
  #      };
  #    Then use the path at runtime:
  #      config.sops.secrets.my_password.path
  #      # → /run/secrets/my_password
  #
  # More docs: https://github.com/mic92/sops-nix
  

  sops = {
    # Age key used to decrypt secrets on this machine
    age.keyFile = "/home/gnister/.config/sops/age/keys.txt";

    # defaultSopsFile = ./secrets/common.yaml;  # uncomment once you have one

    # Example secret declaration (uncomment + adapt):
    # secrets.example_secret = {
    #   sopsFile = ./secrets/common.yaml;
    #   owner    = "gnister";
    # };
  };
}
