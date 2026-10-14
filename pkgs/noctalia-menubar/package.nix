{
  lib,
  stdenvNoCC,
  python3,
  nixos-icons,
}:
stdenvNoCC.mkDerivation {
  pname = "noctalia-menubar";
  version = "2.0.0";

  src = ./plugin;

  dontConfigure = true;
  dontBuild = true;

  # the helper script and the logo are pinned to store paths instead of whatever
  # python3 is on PATH and /run/current-system
  installPhase = ''
    runHook preInstall

    dir=$out/share/noctalia/plugins/menubar
    mkdir -p $dir
    cp -r . $dir

    substituteInPlace $dir/bin/menubar-wm \
      --replace-fail "#!/usr/bin/env python3" "#!${python3}/bin/python3"
    substituteInPlace $dir/logo.luau \
      --replace-fail "/run/current-system/sw/share/icons" "${nixos-icons}/share/icons"

    runHook postInstall
  '';

  meta = {
    description = "macOS-style menu bar for noctalia on niri and Hyprland: Apple menu, app menu, Spotlight and Control Center";
    platforms = lib.platforms.linux;
  };
}
