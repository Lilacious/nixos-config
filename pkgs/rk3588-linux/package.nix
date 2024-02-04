{
  fetchzip,
  linuxManualConfig,
  ...
}:
(linuxManualConfig {
  version = "6.8-collabora-rk3588";
  modDirVersion = "6.8-rc1";

  src = fetchzip {
    url = "https://gitlab.collabora.com/hardware-enablement/rockchip-3588/linux/-/archive/v6.8-rc1/linux-v6.8-rc1.zip";
    sha256 = "sha256-44YfESw5J8WwSkB+A538aa+0e6U4m06XynOP42No2WY=";
  };

  configfile = ./linux-rockchip-rk3588-collabora.config;

  allowImportFromDerivation = true;
})
