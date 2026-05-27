{ inputs, lib, ... }:
{
  imports =
    lib.filter
      (f: baseNameOf f == "default.nix")
      (lib.filesystem.listFilesRecursive ../modules)
    ++ [ ../modules/global/constants.nix ]
    ++ map (host: ../hosts/${host}/default.nix)
         (builtins.attrNames (builtins.readDir ../hosts));
}