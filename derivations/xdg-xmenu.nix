{
  stdenv,
  fetchFromGitHub,
  inih,
}:
stdenv.mkDerivation {
  pname = "xdg-xmenu";
  version = "v1.0.0-beta.2";
  buildInputs = [inih];
  src = fetchFromGitHub {
    owner = "xlucn";
    repo = "xdg-xmenu";
    rev = "d03160ef06813644e7eb45e03a26ade096bcac11";
    hash = "sha256-RtLMtwnXmuutudZslFU2+8+whN2wAzi/ViM44Rr7gI0=";
  };
  buildPhase = ''
    make
  '';
  installPhase = ''
    make install PREFIX= DESTDIR=$out
  '';
}
