{ lib }:

let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) concatStringsSep escapeShellArg;
in

{
  /**
    Wrap the main program of `package` with environment variables and extra
    arguments. The other files of the package are linked through unchanged.

    # Example

    ```nix
    wrapProgram pkgs pkgs.hello {
      envs.set.GREETING = "hi";
      envs.prefix.PATH = lib.makeBinPath [ pkgs.cowsay ];
      args = [ "--traditional" ];
    }
    ```
  */
  wrapProgram =
    pkgs: package:
    {
      name ? "${lib.strings.getName package}-wrapped",
      envs ? { },
      args ? [ ],
    }:
    let
      program = baseNameOf (lib.meta.getExe package);

      flags =
        mapAttrsToList (n: v: "--set ${escapeShellArg n} ${escapeShellArg v}") (envs.set or { })
        ++ mapAttrsToList (n: v: "--prefix ${escapeShellArg n} : ${escapeShellArg v}") (envs.prefix or { })
        ++ map (arg: "--add-flags ${escapeShellArg arg}") args;
    in
    pkgs.symlinkJoin {
      inherit name;
      inherit (package) meta;
      paths = [ package ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/${program} ${concatStringsSep " " flags}";
    };
}
