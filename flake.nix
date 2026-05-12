{
  description = "NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
  let
    system = "x86_64-linux";

    # Helper for workstation hosts (laptop + desktop)
    mkWorkstation = hostname: isDesktop: extraModules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostname}
          ./modules/common.nix
          ./modules/workstation.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs isDesktop; };
            home-manager.users.gnister = import ./home/gnister;
          }
        ] ++ extraModules;
      };

    # Helper for headless/server hosts
    mkServer = hostname: extraModules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostname}
          ./modules/common.nix
          sops-nix.nixosModules.sops
        ] ++ extraModules;
      };
  in
  {
    nixosConfigurations = {
      laptop  = mkWorkstation "laptop"  false [];
      desktop = mkWorkstation "desktop" true  [];
      server  = mkServer      "server"        [];
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nixos-wsl.nixosModules.default
          ./hosts/wsl
          ./modules/common.nix
          # No workstation.nix - WSL has no display manager
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
