{ config, pkgs, username, unstable, self, wrappers, neovim-nightly, ... }:

{
    imports = [
        (wrappers.lib.mkInstallModule {
            loc = [ "home" "packages" ];
            name = "neovim";
            value = wrappers.lib.wrapperModules.neovim;
        })
    ];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.packages = with pkgs; [
		unstable.claude-code

        asciiquarium
		gcc
		go
        lazygit
        nodejs_24
        obsidian
		python3
        ripgrep
		tealdeer
        tmux
        unzip
        wget
        zsh
    ];

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
            ll = "ls -l";
            lg = "lazygit";
            nv = "nvim";
        };

    };

    programs.git = {
        enable = true;
        userName = "jim-landers";
        userEmail = "jimlanders01@gmail.com";
    };

    programs.tmux = {
        enable = true;
		extraConfig = builtins.readFile "${self}/.config/tmux/.tmux.conf";
    };

    wrappers.neovim = { pkgs, lib, ... }: {
        enable = true;
        package = neovim-nightly;
    };
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${self}/.config/nvim";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
