# Reproduce Steps

## Local Environment Info

My daily development environment, running on VMware workstation Player, Windows 11 as host

![screenshot](./screenshot.png)

## Install NixOS

1. Follow the [manual](https://nixos.org/manual/nixos/stable/index.html) installation guide

2. Post installation

    a. enable vmware-tools

    ```nix
    virtualisation.vmware.guest.enable = true;
    ```
    b. hiDPI settings

    See [nixos wiki: Xorg](https://nixos.wiki/wiki/Xorg)

## Nix Flake installation

    [FlakeGuide](https://nixos.wiki/wiki/Flakes)

## Run `sudo nixos-rebuild --flake ".#hostname"`

## Post configuration

1. GNUPG

2. SSH

3. ...
