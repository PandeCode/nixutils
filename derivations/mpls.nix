{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "mpls";
  version = "0.12.1";

  src = pkgs.fetchurl {
    url = "https://github.com/mhersson/mpls/releases/download/v${version}/mpls_${version}_linux_amd64.tar.gz";
    sha256 = "1zjg4kwa0amq6jk4dlg8jpbqidfpf11a44j4202mliplyi9lpwp3";
  };

  phases = ["unpackPhase" "installPhase"];

  unpackPhase = ''
    mkdir -p $out/bin
    tar -xzf $src --strip-components=0
  '';
  installPhase = ''
    chmod +x mpls
    mv mpls $out/bin/
  '';

  meta = {
    description = "Markdown Preview Language Server";
    homepage = "https://github.com/mhersson/mpls";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "mpls";
    platforms = lib.platforms.all;
  };
}
