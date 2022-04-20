# Reproduce Steps

## Local Environment Info

My daily development environment, running on VMware workstation Player, Windows 11 as host

![screenshot](./screenshot.png)

> Background image source: https://unsplash.com/photos/5Lw1U5BIumE

## Install NixOS

- Without flakes

    1. Follow the [manual](https://nixos.org/manual/nixos/stable/index.html) installation guide

    2. Post installation

        a. enable vmware-tools

        ```nix
        virtualisation.vmware.guest.enable = true;
        ```
        b. hiDPI settings

        See [nixos wiki: Xorg](https://nixos.wiki/wiki/Xorg)
        
        c. [install nix flakes](https://nixos.wiki/wiki/Flakes)
        
        d. rebuild whole system with `sudo nixos-rebuild --flake "dot#be"`
        
        e. GUNPG | SSH
        
- With flakes
  
  Follow the [manual](https://nixos.org/manual/nixos/stable/index.html) installation guide, replace 2.3.5 command with the following
  
    ```nix
    # enter a shell env(with nix flakes installed)
    nix-shell -p nixFlakes git
    # clone dot repo using git
    git clone https://github.com/beetcb/dot.git /mnt/etc/nixos/dot
    # replace hardware configruation with newly generated one
    cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/dot/sp-hardware.nix
    # finally, install nixos
    nixos-install --impure --flake /mnt/etc/nixos/dot#be
    ```

# Nix/NixOS Gotchas

> Bellow is a list of gotchas I've encountered with nix, record them as a reminder.

- [Installed sys lib not found by build tools?](https://nixos.wiki/wiki/FAQ/I_installed_a_library_but_my_compiler_is_not_finding_it._Why%3F)

# Channels

- For system pkgs: nixos latest statble channel
- For user pkgs: mixin of nixos latest unstatble & statble channel
