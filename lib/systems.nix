{ lib }:

let
  inherit (lib.attrsets) genAttrs;
in

rec {
  defaultSystems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  forSystems = genAttrs;

  forAllSystems = forSystems defaultSystems;

  /**
    Like `forAllSystems`, but `fn` gets the package set of the given nixpkgs
    for each system instead of the system name.

    # Example

    ```nix
    packages = forAllPkgs inputs.nixpkgs (pkgs: {
      default = pkgs.hello;
    });
    ```
  */
  forAllPkgs = nixpkgs: fn: forAllSystems (system: fn nixpkgs.legacyPackages.${system});
}
