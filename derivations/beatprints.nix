{
  pkgs,
  lib,
}: let
  inherit (pkgs) python3;
  inherit (pkgs) fetchPypi;
in
  python3.pkgs.buildPythonApplication rec {
    pname = "beatprints";
    version = "1.1.3";
    pyproject = true;
    doCheck = false;
    strictDeps = false;
    pythonImportsCheck = ["BeatPrints"];

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-qPmvZs6nQq629zp2TNhKXO6C+EJuZAD8NjcSg/p00Vg=";
    };

    build-system = [python3.pkgs.poetry-core];

    dependencies = with python3.pkgs; [
      black
      fonttools
      pillow
      questionary
      requests
      rich
      toml

      (import ./pylette.nix {inherit pkgs lib;})
      (import ./lrclibapi.nix {inherit pkgs lib;})
    ];

    meta = {
      description = "Create eye-catching, pinterest-style music posters effortlessly";
      homepage = "https://pypi.org/project/BeatPrints/";
      mainProgram = "beatprints";
    };
  }
