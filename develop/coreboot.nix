{ pkgs, ... }:
{
  devShells.coreboot = pkgs.mkShell {
    packages = with pkgs; [
      cacert
      gdb
      git
      qemu
      ncurses
      openssl
      coreboot-toolchain.i386
      pkg-config
      openssh
      cmocka
      python3
    ];
  };
}
