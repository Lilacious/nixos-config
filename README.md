# Nix config

My configuration flake for NixOS, macOS, WSL2 and other Linux distributions
with Nix package manager implementation installed.

## Prerequisites
A Nix package manager implementaion is required. On non-NixOS systems, the
prefered method to install a Nix implementation is the
[Lix installer](https://git.lix.systems/lix-project/lix-installer).

You can install Lix using the aforementioned Lix installer:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install
```
- To bypass the confirmation step of the installer, append `--no-confirm`.

- To install without systemd init system, append `linux --init none` on Linux
or `--init none` on WSL2.

## NixOS Installation #TODO
Boot an NixOS installer ISO image.

Create, format and mount needed partitions.

<details><summary>Encrypted root setup</summary>

- create root and boot partitions (swap optional)

- format the root partition with the luks structure
```
cryptsetup luksFormat /dev/sdx3
```
- open the encrypted partition and map it to /dev/mapper/cryptroot
```
cryptsetup luksOpen /dev/sdx3 cryptroot
```
- format cryptroot
```
mkfs.ext4 -L nixos /dev/mapper/cryptroot
```
- mount encrypted root
```
mount /dev/disk/by-label/nixos /mnt
```
- create boot directory in root
```
mkdir /mnt/boot
```
- mount boot partition to boot directory
```
mount /dev/sda1 /mnt/boot
```
- generate hardware-config.nix
```
nixos-generate-config --root /mnt --dir path/to/nixos-config/hosts/HOST
```

</details>

Generate `hardware-configuration.nix` in `./host/<host>`

```
cd <repo>
```
```
$ nixos-install --flake .#<host>
```
## macOS
You install nix-dawin by running:
```
nix run nix-darwin -- switch --flake .#darwin-arm
```
- Change darwin-arm to your prefered darwinConfiguration host or create a
new host using the entries in `hosts/generics/darwin` as template.
- After installing nix-darwin, you can run `update` to apply changes to your
system.
## Uninstalling
(macOS only) Remove nix-darwin first by running:

```bash
nix run nix-darwin#darwin-uninstaller
```

You can remove a lix-installer-installed Nix by running:
```bash
/nix/lix-installer uninstall
```