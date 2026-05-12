{ pkgs, ... }:
{
  devShells.security = pkgs.mkShell {
    packages = with pkgs; [
      lynis # Security auditing tool
      wireshark # Network protocol analyzer
    ];
  };
}
