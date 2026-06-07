{
  description = "project templates";

  nixConfig = {
    trusted-users = ["root" "shawn"];
    experimental-features = ["nix-command" "flakes" "pipe-operators"];
    accept-flake-config = true;
    show-trace = true;
    auto-optimise-store = true;

    # substituters = ["https://aseipp-nix-cache.freetls.fastly.net"];

    extra-substituters = [
      "https://charon.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "charon.cachix.org-1:epdetEs1ll8oi8DT8OG2jEA4whj3FDbqgPFvapEPbY8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    hermes = {
      url = "github:pandecode/hermes";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    libys = {
      url = "github:pandecode/libys";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    boomer.url = "github:nilp0inter/boomer";
  };

  outputs = {self, ...} @ inputs: rec {
    nix.nixPath = ["nixpkgs=${self.inputs.nixpkgs}"];
    inherit inputs;

    checks = {};
    lib = (import ./lib.nix) inputs.nixpkgs;
    pkgLib = import ./lib.nix;

    packages = lib.forAllSystems ((import ./packages.nix) (self // {}));

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
          find project_name -type f -exec sed -i 's/{{template}}/project_name/g' {} +
          cd project_name
          zig init -m
        '';
      };
    };
  };
}
