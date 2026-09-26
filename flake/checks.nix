{ pkgs, self }:

let
  inherit (pkgs) lib;
  inherit (pkgs.stdenv.hostPlatform) system;

  failures = import ../tests {
    inherit lib pkgs;
    utils = self.lib;
  };
in

{
  formatting = self.formatter.${system}.check self;

  lib =
    assert lib.asserts.assertMsg (failures == [ ])
      "nixutils lib tests failed:\n${lib.generators.toPretty { } failures}";
    pkgs.runCommandLocal "nixutils-lib-tests" { } "touch $out";

  # zig itself parses what toZON writes
  zon-parses =
    let
      sample = pkgs.writeText "sample.zon" (
        self.lib.toZON {
          name = "rill";
          gaps = [
            9
            (-1)
            0.5
          ];
          center = self.lib.zon.enum "always";
          "not an id" = ''
            quote " backslash \ newline
          '';
          cursor = null;
        }
      );
    in
    pkgs.runCommandLocal "nixutils-zon-parses" { nativeBuildInputs = [ pkgs.zig ]; } ''
      cp ${sample} sample.zon
      ZIG_GLOBAL_CACHE_DIR=$TMPDIR zig fmt sample.zon
      touch $out
    '';

  wrap-program =
    let
      show = pkgs.writeShellScriptBin "show" ''echo "$GREETING $*"'';
      wrapped = self.lib.wrapProgram pkgs show {
        envs.set.GREETING = "hi";
        args = [ "--flag" ];
      };
    in
    pkgs.runCommandLocal "nixutils-wrap-program" { } ''
      [ "$(${lib.meta.getExe wrapped} there)" = "hi --flag there" ]
      touch $out
    '';
}
