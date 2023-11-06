{ pkgs, stdenv, lib, fetchurl, autoPatchelfHook, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "go-vod";
  version = "0.1.25";

  src = fetchurl {
    url = "https://github.com/pulsejet/go-vod/releases/download/0.1.25/go-vod-amd64";
    sha256 = "1rh88y9xg9qjm6a0pkxy27jrk0krgpyxmgf3b4mwmn2nyq1nv12g";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  dontUnpack = true;

  dontBuild = true;

  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -m755 -D ${src} $out/bin/go-vod
    runHook postInstall
  '';
}
