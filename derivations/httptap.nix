{
  lib,
  pkgs,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "httptap";
  version = "v0.0.5";

  src = pkgs.fetchurl {
    url = "https://github.com/monasticacademy/httptap/releases/download/${version}/httptap_linux_x86_64.tar.gz";
    sha256 = "1jgss98yzzcqgmx320w9sl28h4by7cbpqc09619ymv4l18vn56iv";
  };
  phases = ["unpackPhase" "installPhase"];
  unpackPhase = ''
    mkdir -p $out/bin
    tar -xzvf $src
  '';
  installPhase = ''
    chmod +x httptap
    mv httptap $out/bin
  '';

  meta = {
    description = "View HTTP/HTTPS requests made by any Linux program";
    homepage = "https://github.com/myhops/httptap";
    mainProgram = "httptap";
  };
}
