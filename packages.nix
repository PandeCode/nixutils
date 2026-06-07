self: let
  inherit (self) inputs;
  inherit (inputs) nixpkgs;
in
  system: let
    pkgs = nixpkgs.legacyPackages.${system};
    derivations = (import ./derivations/default.nix) pkgs;
  in
    derivations
    // rec {
      default = cachix;
      cachix = pkgs.buildEnv {
        name = "cachix";
        paths = with inputs; (
          (builtins.attrValues derivations)
          ++ [
            niri.packages.${system}.niri-unstable
            zig-overlay.packages.${system}.master
          ]
          ++ (map (
              v:
                v.packages.${system}.default
            ) [
              nix-alien
              hermes
              libys
              boomer
              ghostty
              # inputs.zen-browser.packages."${system}".twilight
            ])
        );
      };
    }
