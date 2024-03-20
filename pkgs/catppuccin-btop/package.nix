{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-btop";
  version = "2023-08-07";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
    hash = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
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
    maintainers = with maintainers; [lilacious];
    platforms = platforms.all;
  };
}
