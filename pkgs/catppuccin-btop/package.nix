{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-btop";
  version = "2024-09-23";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "f437574b600f1c6d932627050b15ff5153b58fa3";
    hash = "sha256-mEGZwScVPWGu+Vbtddc/sJ+mNdD2kKienGZVUcTSl+c=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/btop/themes/
    cp -rv themes/* $out/share/btop/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel themes for btop";
    homepage = "https://github.com/catppuccin/btop";
    license = licenses.mit;
    maintainers = with maintainers; [ lilacious ];
    platforms = platforms.all;
  };
}
