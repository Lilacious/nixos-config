## From rafaelsgirao's nixos-config on github

{ lib, buildGoModule, fetchFromGitHub, ... }:
buildGoModule rec {
  pname = "go-vod";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "pulsejet";
    repo = pname;
    rev = "${version}";
    hash = "sha256-OTi1ouMLHOrCIg1HL6I7tLz/p6y5uE8GQxL3jFSuKB0=";
  };

  deleteVendor = true;
  vendorHash = null;
}
