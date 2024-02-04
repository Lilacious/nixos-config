
{ stdenv
, fetchFromGitLab
, buildLinux
, modDirVersionArg ? null
, ... } @ args:

let
  inherit (stdenv.lib)
    concatStrings
    intersperse
    take
    splitString
    optionalString
  ;
in
(
  buildLinux (args // rec {
    version = "6.8-rc1";

    modDirVersion = if (modDirVersionArg == null) then concatStrings (intersperse "." (take 3 (splitString "." "${version}.0"))) else modDirVersionArg;

    extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

    src = fetchFromGitLab {
      domain = "gitlab.collabora.com";
      owner = "rockchip-3588";
      repo = "linux";
      rev = "${version}";
      sha256 = "0awqab6a7rsmyd87icg4yir3za084664j50hclgw6hkpl0ppmpsd";
    };

    postInstall = (optionalString (args ? postInstall) args.postInstall) + ''
      mkdir -p "$out/nix-support"
      cp -v "$buildRoot/.config" "$out/nix-support/build.config"
    '';
  } // (args.argsOverride or {}))
)
