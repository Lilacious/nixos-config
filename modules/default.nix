{ config, lib, ... }:

with lib;
{
  imports = [
    ./common
    ./desktop
    ./programs
    ./services
  ];
}
