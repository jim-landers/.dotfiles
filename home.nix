{ config, pkgs, ... }:

{
    # Home Manager needs a bit of information about you and the paths it should manage.
    home.username = "home";
    home.homeDirectory = "/home/home";

    home.packages = with pkgs; [
        asciiquarium
        claude-code
        gcc
        git
        go
        lazygit
        nodejs_24
        obsidian
        ripgrep
        tmux
        unzip
        wget
        zsh
    ];

    programs.zsh = {
        enable = true;
    };

    programs.git = {
        enable = true;
        userName = "jim-landers";
        userEmail = "jimlanders01@gmail.com";
    };

    programs.tmux = {
        enable = true;

    };

    programs.neovim = {
        enable = true;
        vimAlias = true;
        viAlias = true;
        defaultEditor = true;
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    home.stateVersion = "25.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
