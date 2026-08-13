{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    iterSys = final:
      (
        nixpkgs.lib.genAttrs
        nixpkgs.lib.systems.flakeExposed # this has everything
        # [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      ) ((
          self: system: let
            pkgs = self.inputs.nixpkgs.legacyPackages.${system};
          in
            final {inherit pkgs;}
        )
        self);

    treefmtEval = iterSys ({pkgs, ...}:
      inputs.treefmt-nix.lib.evalModule pkgs (_: {
        projectRootFile = "flake.nix";
      }));
  in {
    formatter = iterSys ({pkgs, ...}: treefmtEval.${pkgs.system}.config.build.wrapper);
    checks = iterSys ({pkgs, ...}: {
      formatting = inputs.treefmtEval.${pkgs.system}.config.build.check self;
    });

    # templates = {
    #   default = {
    #     path = ./.;
    #   };
    # };
    devShells = iterSys (
      {pkgs}: {
        default = pkgs.mkShell {
          packages = [
          ];
        };
      }
    );
  };
}
