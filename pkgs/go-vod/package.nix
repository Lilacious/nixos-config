{
  buildGoModule,
  fetchgit,
  ...
}:
buildGoModule {
  pname = "go-vod";
  version = "0.2.4";

  src =
    (fetchgit {
      url = "https://github.com/pulsejet/memories.git";
      sparseCheckout = [
        "go-vod"
      ];
      rev = "f5627da48868988615f17e5a5b66215cabf37323";
      sha256 = "sha256-ZP+8/Bdm3QBOJztizdm21m9vwB0BJYMbjPJvDr4/iC8=";
    })
    + "/go-vod";

  deleteVendor = true;
  vendorHash = null;
}
