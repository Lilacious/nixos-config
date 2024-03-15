# Nix(OS) configuration files

new implementation that supports multiple users

## Installation

Create, format and mount needed partitions.

Generate `hardware-configuration.nix` in `./host/<host>`

```
cd <repo>
$ nixos-install --flake .#<host>
```
