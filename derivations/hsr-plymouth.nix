{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "plymouth-simulated-universe";
  version = "unstable-2023-08-17";

  src = fetchFromGitHub {
    owner = "ohaiibuzzle";
    repo = "Plymouth-SimulatedUniverse";
    rev = "c990d0a59c41def5adbffc3995c5d59c30843c77";
    sha256 = "ErLBgxp8WB+PhyG7YFs8IaQN7V1+N4afx6OwkTwIUgA=";
  };

  postPatch = ''
    # Remove not needed files
    rm -fr README SimulatedUniverse install.sh
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/
    cp -r SimulatedUniverse-4k $out/share/plymouth/themes/SimulatedUniverse
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
  '';

  passthru.updateScript = unstableGitUpdater {};
  meta = {
    description = "Honkai: Star Rail's Simulated Universe loading screen for your (Linux) computer";
    homepage = "https://github.com/ohaiibuzzle/Plymouth-SimulatedUniverse/";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    platforms = lib.platforms.all;
  };
}
