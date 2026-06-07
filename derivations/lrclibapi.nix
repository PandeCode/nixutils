{
  lib,
  pkgs,
}:
with pkgs;
with python3;
with python3Packages;
  buildPythonPackage rec {
    pname = "lrclibapi";
    version = "0.3.1";
    pyproject = true;
    doCheck = false;
    strictDeps = false;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-a8RXcl+w/Ju4k57a8RLAx5mXUExU6cBBEsF0AwaogIg=";
    };

    build-system = [
      poetry-core
    ];

    dependencies = [
      requests
    ];

    pythonImportsCheck = [
      "lrclibapi"
    ];

    meta = {
      description = "Python wrapper for the lrclib.net api";
      homepage = "https://pypi.org/project/lrclibapi/";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [];
    };
  }
