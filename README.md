# Hydenix+Impermance

This is my personal NixOS configuration repository.

> [!WARNING]
> NixOS is not for beginners!!!
> Make sure you know what you are doing before executing anything!!!

> [!WARNING]
> I just got my system setup, so this README file is not completed yet.
> Please don't try to use this repo to setup your NixOS until I complete the tutorial.

## Features

1. Use [impermanence](https://github.com/nix-community/impermanence) for a minimal installation, 
guide by the great NixOS contributor: [Vimjoyer's Perfect NixOS | impermanence Setup](https://www.youtube.com/watch?v=YPKwkWtK7l0)
2. Use [hydenix](https://github.com/richen604/hydenix) as the Hyperland desktop environment, it's a nixos implementation of hyprdots, a hyprland dotfiles configuration.
3. Use [thundertheidiot solution about persisting /etc/shadow file](https://github.com/nix-community/impermanence/issues/120#issuecomment-2382674299) to allow users be able to change their password after the installation.

## How to use

### Preperation
1. Downloads the minimal ISO image from [NixOS official page](https://nixos.org/download/) because the hydenix is designed based on the minimal installation.
2. Use a tool like [ventoy](https://www.ventoy.net/en/index.html) to build a NixOS usb boot driver.

### Minimal Install
1. [Booting from the install medium](https://nixos.org/manual/nixos/stable/#sec-installation-manual)
2. `git clone https://gitee.com/jackwenyoung/nixos-impermanence.git`
3. Run `git checkout -b first-minimal --trace origin/first-minimal` to check out to the **first-minimal** branch.
> [!WARNING]
> TO BE DONE

### Hydenix Install
> [!WARNING]
> TO BE DONE

