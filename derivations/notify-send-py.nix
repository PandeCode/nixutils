{
  lib,
  glib,
  python3,
  fetchPypi,
  gtk3,
  wrapGAppsHook3,
  gobject-introspection,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "notify-send-py";
  version = "1.2.7";
  pyproject = true;
  doCheck = false;
  strictDeps = false;

  src = fetchPypi {
    pname = "notify-send.py";
    inherit version;
    hash = "sha256-9olZRJ9q1mx1hGqUal6XdlZX6v5u/H1P/UqVYiw9lmM=";
  };

  build-system = [
    python3.pkgs.flit-core
  ];

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    dbus-python
    glib
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      flit
      pygments
    ];
  };

  meta = with lib; {
    description = "Script and module for sending desktop notifications";
    homepage = "https://pypi.org/project/notify-send.py/";
    license = licenses.bsd2;
    mainProgram = "notify-send-py";
  };
}
