# Dotfiles

The goal with how I have this repository structured is to make it as smooth as (reasonably) possible to port my dotfiles to any machine. Even if it does not have Nix, symlinking/copying program configuration
files from this repo should do the job.

Currently I have a pretty long way to go with nix-ifying all my stuff, so this is all fairly work in progress.

## NixOS Setup

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

**Note:** This repo must be cloned to `~/.dotfiles`. Some configs use live symlinks to make on the fly changes take effect without needing to rebuild. (e.g. nvim)

```sh
git clone https://github.com/jim-landers/.dotfiles.git ~/.dotfiles
```



