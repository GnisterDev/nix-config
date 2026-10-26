{
  flake.modules.nixos.base = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          type = "ed25519";
          path = "/etc/ssh/ssh_host_ed25519_key";
        }
      ];
    };
  };

  flake.modules.homeManager.base = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      # Upstream ssh_config directive names; add hosts as more entries.
      settings."*" = {
        AddKeysToAgent = "yes";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "10m";
        HashKnownHosts = "no";
      };
    };
  };
}
