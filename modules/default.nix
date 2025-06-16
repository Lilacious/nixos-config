{ lib, ... }:
with lib;
{
  imports = [
    ./desktop
    ./other
    ./programs
    ./services
  ];
}
