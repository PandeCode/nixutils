{
  description = "lib and project templates";

  nixConfig = {
    experimental-features = ["nix-command" "flakes" "pipe-operators"];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {self, ...} @ inputs: rec {
    nix.nixPath = ["nixpkgs=${self.inputs.nixpkgs}"];
    inherit inputs;
    checks = {};
    lib = (import ./lib.nix) inputs.nixpkgs;
    pkgLib = import ./lib.nix;

    templates = {
      default = {
        path = ./default;
        description = "i dont understand";
      };

      rust = {
        path = ./rust;
        description = "i dont understand";
      };

      c = {
        path = ./c;
        description = "clang clangd gdb|rr valgrind";
      };

      cpp = {
        path = ./cpp;
        description = "clang clangd gdb|rr valgrind";
      };

      zig = {
        path = ./zig;
        description = "Zig project with flake devshell";
        welcomeText = ''
          # Run
          find project_name -type f -exec sed -i 's/__template__/project_name/g' {} +
          cd project_name
          zig init -m
        '';
      };
    };
  };
}
