# My Reproducable Dev Environment using NixOS

## Local Environment Info

My daily development environment, running on VMware Workstation | VMware Fusion | MacOS.

![screenshot](./screenshot.png)

> Background image source: https://unsplash.com/photos/5Lw1U5BIumE

## Install NixOS/Nix(Darwin)

- Without flakes(only on linux vm)

  1. Follow the [manual](https://nixos.org/manual/nixos/stable/index.html) installation guide

  2. Post installation

     a. enable vmware-tools

     ```nix
     virtualisation.vmware.guest.enable = true;
     ```

     b. [hiDPI settings](https://nixos.wiki/wiki/Xorg)

     c. [install nix flakes](https://nixos.wiki/wiki/Flakes)

     d. rebuild whole system with `sudo nixos-rebuild --flake "."`

     e. GUNPG | SSH

- With flakes

  Follow the [manual](https://nixos.org/manual/nixos/stable/index.html) installation guide, replace 2.3.5 command with the following

  ```nix
  # optional dir creation for store dev.nix repo
  sudo mkdir -p /etc/build
  sudo chown -R $(whoami) /etc/build

  # when running on darwin, install nix, then darwin first.
  # enter a shell env(with nix flakes installed)
  nix-shell -p nixFlakes git

  # clone repo using git
  git clone git@github.com:beetcb/dev.nix.git /etc/build/

  # replace hardware configruation with newly generated one(can be safly ignored on darwin)
  cp /mnt/etc/nixos/hardware-configuration.nix /etc/build/os/nixos/hardware.nix

  # finally, install nixos
  ## linux
  sudo nixos-install --impure --flake /etc/build
  ## darwin
  darwin-rebuild switch --flake /etc/build
  ```

# Nix/NixOS/VM Gotchas

> Bellow is a list of gotchas I've encountered, record them as a reminder.

- [Installed sys lib not found by build tools?](https://nixos.wiki/wiki/FAQ/I_installed_a_library_but_my_compiler_is_not_finding_it._Why%3F)
- [Do port forwarding from localhost to vmhost](https://linuxize.com/post/how-to-setup-ssh-tunneling/)
- Defragmenting and shrinking VM disk

  1. [Disable 3D acceleration temporarily](https://communities.vmware.com/t5/VMware-Workstation-Pro/ISBRendererComm-Lost-connection-to-mksSandbox-and-MKS/td-p/2838888), weird bug on vmware workstation.
  2. [Defragmenting and shrinking on guest machine](https://superuser.com/a/1116213)

- OS management helper scripts
  ```bash
  home.shellAliases = {
    vmshare = "vmhgfs-fuse .host:/ /mnt/";
    os-rebuild = "sudo nixos-rebuild switch --flake ${os}#be";
    os-update = ''
      cd ${os} &&
      nix flake update &&
      os-rebuild
    '';
    os-cleanup = ''
      sudo rm -f /nix/var/nix/gcroots/auto/* &&
      nix-collect-garbage -d &&
      sudo nix-collect-garbage -d &&
      os-rebuild
    '';
  };
  ```

# Channels

- For system pkgs: nixos latest statble channel
- For user pkgs: mixin of nixos latest unstatble & statble channel

# Quick options refs
- nix-darwin https://daiderd.com/nix-darwin/manual/index.html
- home-manager https://nix-community.github.io/home-manager/options.html
- nixvim https://pta2002.github.io/nixvim/
