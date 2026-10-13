# Generic hosts to bootstrap new machines, the darwin template
# lives in ../darwin (see comment there)
{
  imports = [
    ./home
    ./nixos
    ./wsl
  ];
}
