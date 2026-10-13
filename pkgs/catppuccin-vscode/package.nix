{
  lib,
  vscode-utils,
  fetchFromGitHub,
  nodejs-slim_24,
  pnpm_11,
  pnpmConfigHook,
  fetchPnpmDeps,

  catppuccinOptions ? { },
}:
let
  nodejs = nodejs-slim_24;
  pnpm = pnpm_11.override { nodejs-slim = nodejs; };
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "catppuccin-vscode";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "vscode";
    tag = "@catppuccin/vscode-v${finalAttrs.version}";
    hash = "sha256-HUXRGK10A3YIU6ksTfzOzQvM5J699lJikndlYUgrkRA=";
  };

  vscodeExtPublisher = "catppuccin";
  vscodeExtName = "catppuccin-vsc";
  vscodeExtUniqueId = "catppuccin.catppuccin-vsc";

  sourceRoot = null;

  pnpmWorkspaces = [ "catppuccin-vsc" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-pycHugIQFpALC6nAnj6r+eZ0Y1lxJ5CzXermOE2MXgk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
  ];

  __structuredAttrs = true;
  strictDeps = true;

  env = lib.optionalAttrs (catppuccinOptions != { }) {
    CATPPUCCIN_OPTIONS = builtins.toJSON catppuccinOptions;
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter catppuccin-vsc core:build --no-regenerate

    cd packages/catppuccin-vsc
    node dist/hooks/generateThemes.cjs
    # marks the extension as installed so it doesn't try to recompile into the store at runtime
    touch ./themes/.flag

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/$installPrefix"
    cp -rL ../../LICENSE ../../README.md package.json icon.png dist/ themes/ "$out/$installPrefix/"

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for VSCode";
    homepage = "https://github.com/catppuccin/vscode";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
