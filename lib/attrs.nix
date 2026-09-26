{ lib }:

{
  forceAttrs = lib.attrsets.mapAttrs (_: lib.modules.mkForce);
}
