# { inputs, ... }:
# {
#   flake.modules.nixos.base = {
#     imports = with inputs.self.modules.nixos; [
#       git
#       locale
#       #networking
#       nh
#       #nix-settings
#       #shell
#       #ssh
#     ];
#   };
# }

_:
{
  flake.modules.nixos.base = { imports = [
    ./git.nix
    ./nh.nix
    ./locale.nix
    ./networking.nix
    ./nix-settings.nix
    ./shell.nix
  ]; };
}
