{ lib }:

lib.fixedPoints.makeExtensible (final: {
  # keep-sorted start
  attrs = import ./attrs.nix { inherit lib; };
  systems = import ./systems.nix { inherit lib; };
  wrappers = import ./wrappers.nix { inherit lib; };
  # keep-sorted end

  treefmtModule = ./treefmt.nix;

  inherit (final.attrs) forceAttrs;
  inherit (final.systems)
    defaultSystems
    forAllPkgs
    forAllSystems
    forSystems
    ;
  inherit (final.wrappers) wrapProgram;
})
