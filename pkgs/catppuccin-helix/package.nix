{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-helix";
  version = "2025-02-17";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "helix";
    rev = "ba13a603ba91cc63c0ef14515111ecc208064469";
    hash = "sha256-/o2/xpcIryI0jW3K4IWa66ydfnMGmGwDhBObFLGbDXo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/helix/themes/
    cp -rv themes/* $out/share/helix/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel themes for helix";
    homepage = "https://github.com/catppuccin/helix";
    license = licenses.mit;
    maintainers = with maintainers; [ lilacious ];
    platforms = platforms.all;
  };
}
