{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "home";
  home.homeDirectory = "/home/home";

  # User packages (migrated from your /etc/nixos configuration)
  home.packages = with pkgs; [
    asciiquarium
    claude-code
    git
    lazygit
    nodejs_24
    tmux
    wget
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "home";
    userEmail = "home@homelab";  # Update this to your email
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    # Add your tmux configuration here
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # Add your neovim configuration here
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
