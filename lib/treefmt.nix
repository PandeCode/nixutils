{ lib, pkgs, ... }:

{
  runtimeInputs = with pkgs; [
    # keep-sorted start
    deadnix
    keep-sorted
    nixfmt
    statix
    # keep-sorted end

    (writeShellScriptBin "statix-fix" ''
      for file in "$@"; do
        ${lib.meta.getExe statix} fix "$file"
      done
    '')
  ];

  settings = {
    on-unmatched = "info";
    tree-root-file = "flake.nix";

    formatter = {
      # keep-sorted start block=yes newline_separated=yes
      deadnix = {
        command = "deadnix";
        options = [ "--edit" ];
        includes = [ "*.nix" ];
      };

      keep-sorted = {
        command = "keep-sorted";
        includes = [ "*" ];
      };

      nixfmt = {
        command = "nixfmt";
        includes = [ "*.nix" ];
      };

      statix = {
        command = "statix-fix";
        includes = [ "*.nix" ];
      };
      # keep-sorted end
    };
  };
}
