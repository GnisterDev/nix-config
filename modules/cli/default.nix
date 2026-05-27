_:
{
  flake.modules.nixos.cli = { imports = [
    ./lazygit.nix
    ./btop.nix
  ]; };
}
