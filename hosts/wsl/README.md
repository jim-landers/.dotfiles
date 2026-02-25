# WSL Host

## Installation

### 1. Install NixOS-WSL

Follow the [**# Install NixOS-WSL**](https://nix-community.github.io/NixOS-WSL/install.html#install-nixos-wsl) section in the official documentation.

### 2. Install Git

Git is not installed by default on NixOS. Once you have a shell, run:

```sh
nix-env -f '<nixpkgs>' -iA git
```

### 3. Apply the Configuration

Build and boot to the configuration directly from GitHub:

```sh
sudo nixos-rebuild boot --flake github:jim-landers/.dotfiles#wsl
```

### 4. Change Username

Follow the [change username instructions](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html) to complete the user setup.

> **Note:** `wsl.defaultUser` is already set in `flake.nix`. Follow the linked instructions for the remaining steps to apply the username change.

### 5. Clone the Dotfiles

Once logged in as your new user, clone the repo into your home directory:

```sh
git clone https://github.com/jim-landers/.dotfiles.git ~/.dotfiles
```
