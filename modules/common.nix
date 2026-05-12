{ config, pkgs, inputs, ... }:
{
  imports = [ ./secrets.nix ];

  # Nix / Nixpkgs settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };

  nixpkgs.config.allowUnfree = true;

  # User
  users.users.gnister = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "networkmanager" "audio" "video" ];
    shell        = pkgs.bash;
    # Set a password with: passwd gnister
    # Or use: initialHashedPassword = "...";
  };

  security.sudo.wheelNeedsPassword = true;

  # Dev tools & CLI packages (all machines)
  environment.systemPackages = with pkgs; [
    # Version control
    git
    lazygit

    # C toolchain
    gcc
    gnumake
    cmake

    # Rust (rustup manages toolchains; run `rustup default stable` after install)
    rustup

    # Go
    go

    # JavaScript / Node ecosystem
    nodejs
    bun
    pnpm

    # Typesetting
    typst

    # Secrets tooling
    age
    sops

    # System helpers
    nh
    wget
    curl
    ripgrep
    fd
    unzip
    zip
    htop
  ];

  # nh - friendly NixOS update helper
  programs.nh = {
    enable    = true;
    clean.enable    = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    # Point this at wherever you keep your flake:
    flake = "/etc/nixos";
  };

  # Shell alias (system-wide bash)
  programs.bash.shellAliases = {
    cls = "clear";
  };

  # Locale & timezone
  time.timeZone       = "Europe/Oslo";
  i18n.defaultLocale  = "en_US.UTF-8";

  # Keep the console in a sensible font
  console = {
    font   = "Lat2-Terminus16";
    keyMap = "no";
  };
}
