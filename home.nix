{ config, pkgs, ... }:

{
  home.username = "sakura";
  home.homeDirectory = "/home/sakura";
  home.stateVersion = "23.05"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;
  xdg.configFile = {
    "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
    "tmux/tmux.conf".source = ./config/tmux/tmux.conf;
  };
  home.packages = with pkgs; [
    fd
    ripgrep
    watchexec
    kubectl
    gradle
    tmux
    zig
    # pkgs.hello
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      userEmail = "sakurapetgirl@live.com";
      userName = "libvirgo";
      extraConfig = {
        credential = {
          helper = "store";
        };
	url."https://".insteadOf = "git://";
      };
    };
    bat.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      #enableSyntaxHighlighting = true;
      syntaxHighlighting = {
      	enable = true;
      };
      defaultKeymap = "emacs";
      shellAliases = {
        cat = "bat -p";
        unpack = "tar -xvf";
        pack = "tar -zcvf archive.tar.gz";
        glog = "git log --oneline --decorate --graph";
        gst = "git status";
        hss = "home-manager switch && source ~/.zshrc";
	kc = "kubectl";
      };
      initExtra = ''
      	export PATH=$HOME/.local/bin:$PATH
      	#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
	export SDKMAN_DIR="$HOME/.sdkman"
	[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
	export PUB_HOSTED_URL=https://pub.flutter-io.cn
	export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
	export PATH="$HOME/.local/share/fnm:$PATH"
	export PATH="$HOME/.local/app/istio/bin:$PATH"
	export PATH="$HOME/.local/app/google-cloud-sdk/bin:$PATH"
	export GRAALVM_HOME=$HOME/.sdkman/candidates/java/17.0.7-graal
  	eval "`fnm env`"
	source "$HOME/.cargo/env"
	source <(ng completion script)
	# The next line updates PATH for the Google Cloud SDK.
	if [ -f '/home/sakura/.local/app/google-cloud-sdk/path.zsh.inc' ]; then . '/home/sakura/.local/app/google-cloud-sdk/path.zsh.inc'; fi
	# The next line enables shell command completion for gcloud.
	if [ -f '/home/sakura/.local/app/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/sakura/.local/app/google-cloud-sdk/completion.zsh.inc'; fi
	if [ -f '/home/sakura/.dotnet/dotnet' ]; then export PATH="$HOME/.dotnet:$PATH" export DOTNET_ROOT=$HOME/.dotnet; fi
	if [ -f '/home/sakura/.local/app/dotnet/_dotnet' ]; then . '/home/sakura/.local/app/dotnet/_dotnet'; fi
	if [ -f '/home/sakura/sdk/go1.21.0/bin/go' ]; then export PATH=$HOME/sdk/go1.21.0/bin:$PATH; fi
      '';
      plugins = [
        {
          name = "powerlevel10k-config";
          src = ./config/zsh;
          file = "p10k-config.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
              owner = "Aloxaf";
              repo = "fzf-tab";
              rev = "69024c27738138d6767ea7246841fdfc6ce0d0eb";
              sha256 = "sha256-yN1qmuwWNkWHF9ujxZq2MiroeASh+KQiCLyK5ellnB8=";
          };
        }
	{
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
      zplug = {
        enable = true;
        plugins = [
          {
            name = "ogham/exa";
            tags = [ use:completions/zsh ];
          }
          {
            name = "djui/alias-tips";
          }
          {
            name = "romkatv/powerlevel10k";
            tags = [ as:theme depth:1 ];
          }
        ];
      };
    };
  };

  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
