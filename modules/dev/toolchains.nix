{
  flake.modules.homeManager.dev =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        # C / C++ (gcc, make and pkg-config come from base)
        # Both compiler wrappers default to priority 10 and collide on cc/cpp;
        # 20 lets gcc keep them (clang, clang++ stay available by name).
        (lib.setPrio 20 clang)
        cmake
        ninja
        gdb

        # Python
        python3
        uv

        # JavaScript / TypeScript
        nodejs
        pnpm

        # Rust
        rustc
        cargo
        clippy
        rustfmt

        # Go
        go
      ];

      programs.java = {
        enable = true;
        package = pkgs.jdk;
      };

      home.sessionVariables.GOPATH = "$HOME/.local/share/go";
    };

  # Run unpatched binaries
  flake.modules.nixos.dev = {
    programs.nix-ld.enable = true;
  };
}
