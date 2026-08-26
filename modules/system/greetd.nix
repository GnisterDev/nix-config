_:
{
  flake.modules.nixos.greetd = { pkgs, ... }: {
    services.greetd.enable = true;
  };
}