# Dotfiles

## Installation / Setup

### 1. Install Git
This step is primarily for a fresh NixOS install because Git is not installed by default.

```sh
nix-env -f '<nixpkgs>' -iA git
```

### 2. Apply the Configuration

Build and boot to the configuration directly from GitHub:

```sh
sudo nixos-rebuild boot --flake github:jim-landers/.dotfiles#<host>
```

### 3. Set Username

In `home.nix`, set `home.username` to your desired username.

### 4. Clone the Dotfiles

Once logged in as your new user, clone the repo into your home directory:

**Note:** This repo must be cloned to `~/.dotfiles`. Some configs use live symlinks that assume this location so that on the fly config changes can take effect without having to rebuild.

```sh
git clone https://github.com/jim-landers/.dotfiles.git ~/.dotfiles
```



