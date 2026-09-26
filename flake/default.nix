inputs:

let
  inherit (inputs) nixpkgs self;

  forAllPkgs = self.lib.forAllPkgs nixpkgs;
in

{
  lib = import ../lib { inherit (nixpkgs) lib; };

  templates = import ../templates;

  formatter = forAllPkgs (
    pkgs:
    pkgs.treefmt.withConfig [
      self.lib.treefmtModule
      # the templates are reworked in their own step
      { settings.excludes = [ "templates/*" ]; }
    ]
  );

  checks = forAllPkgs (pkgs: import ./checks.nix { inherit pkgs self; });

  devShells = forAllPkgs (pkgs: {
    default = pkgs.mkShellNoCC {
      packages = [ self.formatter.${pkgs.stdenv.hostPlatform.system} ];
    };
  });
}
