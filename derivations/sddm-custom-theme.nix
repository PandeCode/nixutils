{
  pkgs,
  stdenvNoCC,
  video ?
    builtins.fetchurl {
      url = "https://github.com/PandeCode/dotnix/raw/refs/heads/media/sddm/chainsaw.mp4";
      sha256 = "1qnb4vjsckd6qvcaimhcsz5j2n32zcr199adyw1509ka70rchx0z";
    },
  placeholder ?
    builtins.fetchurl {
      url = "https://github.com/PandeCode/dotnix/raw/refs/heads/media/sddm/chainsaw.png";
      sha256 = "19p7xngs2gv9yjrdbl755kb1sf3v1n9pa3yrjd4nhj806kksqbfi";
    },
}:
stdenvNoCC.mkDerivation {
  pname = "sddm-custom-theme";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "pandecode";
    repo = "sddm-custom-theme";
    rev = "fb1bbdb15b10b065a14058ef2513b286ffb14e2d";
    hash = "sha256-NmLsJoztWxZFuYqdi4EuxAxBnUIqMVxYfXN+IBHKkFA=";
  };

  dontWrapQtApps = true;

  propagatedBuildInputs = with pkgs.kdePackages; [
    qtsvg
    qtmultimedia
    qtvirtualkeyboard
  ];

  installPhase = let
    basePath = "$out/share/sddm/themes/sddm-custom-theme";
  in ''
    mkdir -p ${basePath}
    mkdir -p ${basePath}/Backgrounds

    cp -r $src/* ${basePath}

    cp -f ${video} ${basePath}/Backgrounds/custom.mp4
    cp -f ${placeholder} ${basePath}/Backgrounds/custom.png
  '';
}
