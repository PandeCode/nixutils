{
  description = "lib and project templates";

  nixConfig = {experimental-features = ["nix-command" "flakes" "pipe-operators"];};

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = {self, ...} @ inputs: rec {
    nix.nixPath = ["nixpkgs=${self.inputs.nixpkgs}"];
    inherit inputs;
    checks = {};
    lib = (import ./lib.nix) inputs.nixpkgs;
    pkgLib = import ./lib.nix;

    templates = {
      default = {
        path = ./templates/nixflake;
        description = "Default flake for modification";
      };

      # rust = {
      #   path = ./rust;
      #   description = "i dont understand";
      # };
      #
      # c = {
      #   path = ./c;
      #   description = "clang clangd gdb|rr valgrind";
      # };
      #
      # cpp = {
      #   path = ./cpp;
      #   description = "clang clangd gdb|rr valgrind";
      # };
      #
      zig = {
        path = ./templates/zig/default_project;
        description = "Zig project with flake devshell, package, {nixos,home}Module ";
        welcomeText =
          ''
            # Run
          ''
          + "sed -i '' -e 's/myproject/default_project/g' $(find . -type f);"
          + ''
            direnv allow;
            zig init -m;
          '';
      };
    };
  };
}
