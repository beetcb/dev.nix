# Reproduce Steps

## Local Environment Info

My daily development environment, running on VMware workstation Player, Windows 11 as host

![screenshot](./screenshot.png)

> Background image source: https://unsplash.com/photos/5Lw1U5BIumE

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

[Flake Guide](https://nixos.wiki/wiki/Flakes)

## Run `sudo nixos-rebuild --flake ".#hostname"`

## Post configuration

1. GNUPG

2. SSH

3. ...

# Nix/NixOS Gotchas

> Bellow is a list of gotchas I've encountered with nix, record them as a reminder.

- [Installed sys lib not found by build tools?](https://nixos.wiki/wiki/FAQ/I_installed_a_library_but_my_compiler_is_not_finding_it._Why%3F)
