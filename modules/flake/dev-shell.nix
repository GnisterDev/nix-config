{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;

      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          nixfmt
          statix
          deadnix
          nil
          nh
          nix-output-monitor
          sops
          age
          ssh-to-age
        ];
      };

      checks.lint =
        pkgs.runCommandLocal "lint"
          {
            nativeBuildInputs = [
              pkgs.statix
              pkgs.deadnix
            ];
          }
          ''
            cd ${inputs.self}
            statix check . --ignore 'hosts/*/_hardware.nix'
            deadnix --fail --no-lambda-pattern-names .
            touch $out
          '';
    };
}
