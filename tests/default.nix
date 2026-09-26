{
  lib,
  pkgs,
  utils,
}:

let
  show = pkgs.writeShellScriptBin "show" "true";

  wrapped = utils.wrapProgram pkgs show {
    envs = {
      set.GREETING = "hi";
      prefix.PATH = "/opt/bin";
    };
    args = [ "--flag" ];
  };

  fakeNixpkgs.legacyPackages = utils.forAllSystems (system: {
    inherit system;
  });
in

lib.debug.runTests {
  # keep-sorted start block=yes newline_separated=yes
  testForAllPkgsUsesGivenNixpkgs = {
    expr = utils.forAllPkgs fakeNixpkgs (pkgs: pkgs.system);
    expected = lib.attrsets.genAttrs utils.defaultSystems (system: system);
  };

  testForAllSystems = {
    expr = builtins.attrNames (utils.forAllSystems (_: null));
    expected = lib.lists.sort lib.strings.versionOlder utils.defaultSystems;
  };

  testForSystems = {
    expr = utils.forSystems [ "a" "b" ] (system: system + "!");
    expected = {
      a = "a!";
      b = "b!";
    };
  };

  testForceAttrs = {
    expr = utils.forceAttrs { a = 1; };
    expected = {
      a = lib.modules.mkForce 1;
    };
  };

  testToZON = {
    expr = utils.toZON {
      gap = 9;
      width = 0.5;
      side = utils.zon.enum "left";
      "bad-name" = null;
      error = true;
      argv = [
        "sh"
        "-c"
        ''echo "hi"''
      ];
      empty = { };
    };
    expected = ''.{ .argv = .{ "sh", "-c", "echo \"hi\"", }, .@"bad-name" = null, .empty = .{}, .@"error" = true, .gap = 9, .side = .left, .width = 0.500000, }'';
  };

  testWrapProgramFlags = {
    expr = map (flag: lib.strings.hasInfix flag wrapped.drvAttrs.buildCommand) [
      "--set GREETING hi"
      "--prefix PATH : /opt/bin"
      "--add-flags --flag"
    ];
    expected = [
      true
      true
      true
    ];
  };

  testWrapProgramKeepsMainProgram = {
    expr = wrapped.meta.mainProgram;
    expected = "show";
  };

  testWrapProgramName = {
    expr = wrapped.name;
    expected = "show-wrapped";
  };
  # keep-sorted end
}
