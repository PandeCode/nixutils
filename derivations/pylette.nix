{
  lib,
  pkgs,
}:
with pkgs;
with python3;
with python3Packages;
  buildPythonPackage rec {
    pname = "pylette";
    version = "4.0.0";
    pyproject = true;
    doCheck = false;
    strictDeps = false;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Nw5oZasXhDZ8Xb98ZlLTWFM5eypKDOwYQdFP1FukK0A=";
    };

    build-system = [
      poetry-core
    ];

    dependencies = [
      numpy
      pillow
      requests
      scikit-learn
      typer
    ];

    pythonImportsCheck = [
      "pylette"
    ];

    meta = {
      description = "A Python library for extracting color palettes from images";
      homepage = "https://pypi.org/project/pylette/";
      license = lib.licenses.mit;
    };
  }
