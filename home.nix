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

	home.sessionVariables = {
		EDITOR = pkgs.lib.getExe config.wrappers.neovim.wrapper;
		VISUAL = pkgs.lib.getExe config.wrappers.neovim.wrapper;
	};

    home.packages = with pkgs; [
		unstable.claude-code

        asciiquarium
		basedpyright
		direnv
		gcc
		go
		gopls
        lazygit
		lua-language-server
		nixd
		nixfmt-rfc-style
        nodejs_24
		python3
        ripgrep
		starship
		stylua
		tealdeer
        tmux
		tree
        unzip
		vtsls
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
            vim = "nvim";
            vi = "nvim";
        };

		oh-my-zsh = {
				enable = true;
				plugins = ["direnv"];
			};

        initContent = builtins.readFile "${self}/.config/zsh/rc.zsh";
    };

	programs.starship = {
        enable = true;
	};

    programs.git = {
        enable = true;
		settings.user.name = "jim-landers";
    };
	programs.lazygit = {
		enable = true;
	};
    xdg.configFile."lazygit".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/lazygit";

    programs.tmux = {
        enable = true;
		extraConfig = builtins.readFile "${self}/.config/tmux/.tmux.conf";
    };

    wrappers.neovim = { pkgs, config, ... }: {
        enable = true;
        package = neovim-nightly;
    };
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/nvim";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
