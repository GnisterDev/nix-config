{ inputs, ... }:
{
  flake.nixosConfigurations = {
    laptop = inputs.self.lib.mkNixos    "x86_64-linux" "laptop";
    wsl    = inputs.self.lib.mkNixosWsl "x86_64-linux" "wsl";
  };
}
