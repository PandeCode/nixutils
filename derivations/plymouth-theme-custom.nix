{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "plymouth-theme-cat";
  version = "unstable-2025-01-09";

  src = fetchFromGitHub {
    owner = "krishnan793";
    repo = "PlymouthTheme-Cat";
    rev = "9f9bbc0e6cb8677684d198eb1139d90aceff82e0";
    hash = "sha256-yNryZkjSDFYGTExCz6Dkoust749QK65JYoCIO2oN+Y4=";
  };

  postPatch = ''
    rm -fr README.md LICENSE README
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/PlymouthTheme-Cat
    cp  ./*  $out/share/plymouth/themes/PlymouthTheme-Cat
    find $out/share/plymouth/themes/PlymouthTheme-Cat -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = {
    description = "This is a Plymouth theme created that can be used in Linux Distributions";
    homepage = "https://github.com/krishnan794/PlymouthTheme-Cat";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
