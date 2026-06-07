{
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
  config ? {
    background = null;
    main = null;
    secondary = null;
  },
}:
stdenvNoCC.mkDerivation rec {
  pname = "plymouth-theme-chain";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Hugopikachu";
    repo = "plymouth-theme-chain";
    rev = "v${version}";
    hash = "sha256-qvCzYK5Ti/YH7c6rg0AJS/C/efe4cERLY9tS+WFmluM=";
  };

  meta = {
    description = "";
    homepage = "https://github.com/Hugopikachu/plymouth-theme-chain/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "plymouth-theme-chain";
    platforms = lib.platforms.all;
  };
  postPatch = ''
    # Remove not needed files
    rm -fr README.md LICENSE preview
  '';
  dontBuild = true;

  nativeBuildInputs = with pkgs;
    if
      (
        !(builtins.isNull config.background)
        || !(builtins.isNull config.main)
        || !(builtins.isNull config.secondary)
      )
    then [
      imagemagick
    ]
    else [];

  installPhase =
    "chmod +x change-color.sh\n"
    + (
      if builtins.isNull config.background
      then ""
      else "./change-color.sh background ${config.background}\n"
    )
    + (
      if builtins.isNull config.main
      then ""
      else "./change-color.sh main ${config.main}\n"
    )
    + (
      if builtins.isNull config.secondary
      then ""
      else "./change-color.sh secondary ${config.secondary}\n"
    )
    + #bash
    ''
      sed -i "s@\/usr\/@$out\/@" chain.plymouth
      mkdir -p $out/share/plymouth/themes/chain
      cp -r ./* $out/share/plymouth/themes/chain
    '';

  passthru.updateScript = unstableGitUpdater {};
}
