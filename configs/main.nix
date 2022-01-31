{ config, pkgs, ... }:

let shellAliases = {
  os = "openstack";
  k = "kubectl";
  docker = "sudo docker";
  watch = "watch --color";
};

in {
  imports = [
    ./terminal.nix
    ./ssh.nix
    ./i3.nix
    ./polybar.nix
    #TODO./redshift.nix
    ./rofi.nix
    #TODO./vscode.nix
    #./neovim.nix
  ];

  programs.neovim = {
  enable = true;
  extraConfig = ''
    colorscheme nord
    let g:context_nvim_no_redraw = 1
    set mouse=a
    set number
    set termguicolors
    '' + "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF
  ";
  plugins = with pkgs.vimPlugins;
    let
      context-vim = pkgs.vimUtils.buildVimPlugin {
        name = "context-vim";
        src = pkgs.fetchFromGitHub {
          owner = "wellle";
          repo = "context.vim";
          rev = "e38496f1eb5bb52b1022e5c1f694e9be61c3714c";
          sha256 = "1iy614py9qz4rwk9p4pr1ci0m1lvxil0xiv3ymqzhqrw5l55n346";
        };
      };
    in [
      context-vim
      editorconfig-vim
      gruvbox-community
      vim-airline
      vim-elixir
      vim-nix
      nvim-tree-lua
      nvim-cmp
      nord-vim
    ]; # Only loaded if programs.neovim.extraConfig is set
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  };

  nixpkgs.config.allowUnfree = true;

  programs.command-not-found.enable = true;
  home.packages = with pkgs; [
    pinentry
    yubikey-personalization
    htop
    traceroute
    tig
    discord
    slack
    thunderbird
    pavucontrol
    spotify
    atom
    xfce.thunar
    betterlockscreen
    nixUnstable
    betterlockscreen
    etcher
    dunst
    libnotify
    brightnessctl
    texmaker
    gimp
    krb5
    virt-manager
    wireshark
    apache-directory-studio
    pstree
    sl
    qemu_kvm
    torrential
    pciutils
    xbindkeys
    wpa_supplicant_gui
    zip
    ncat
    hwinfo
    poetry
    lshw
    dhcp
    tftp-hpa
    iputils
    autoconf
    freerdp
    openssl
    nodePackages.npm
    docker-compose
    nodejs
    dpkg
    jetbrains.pycharm-professional
    ansible
    teams
    kubectl
    ipcalc
    vault
    pixiecore
    whois
  ];

  programs.fzf = { enable = true; };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      status.symbol = "❌ ";
      status.disabled = false;
      aws.disabled = true;
      gcloud.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    defaultKeymap = "viins";
    history.extended = true;
    plugins = with pkgs; [
      {
        name = "first-tab-completion";
        src = lib.cleanSource ./.;
        file = "first-tab-completion.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = zsh-history-substring-search;
        file =
          "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    initExtra = with pkgs; ''
      export KEYTIMEOUT=1

      ZSH_AUTOSUGGEST_USE_ASYNC=1
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      zmodload zsh/complist
      zstyle ':completion:*' menu select
      zstyle ':completion:*' insert-tab false
      bindkey '^I' first-tab-completion
      bindkey -M menuselect '\e' send-break
      bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history

      bindkey -M viins '^?' backward-delete-char
      bindkey -M viins '^H' backward-delete-char

      setopt HIST_FIND_NO_DUPS
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down

      setopt extendedglob
      setopt kshglob
    '';
    inherit shellAliases;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    extraConfig = ''
    pinentry-program ${pkgs.pinentry}/bin/pinentry
    '';
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Pierre 'rootmout' Kelbert";
    userEmail = "rootmout@cri.epita.fr";
    signing.key = "2D5A45757936C8F7";
    signing.signByDefault = true;
    extraConfig = {
      branch.autosetuprebase = "always";
      pull.rebase = true;
      push.default = "simple";
    };
  };

  programs.autorandr = {
    enable = true;
  };

  # for .envrc's in child directories add "source_up"
  # for them to pick up this config
  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
  };
  home.file."dev/work/.envrc".text = ''
    dotenv
  '';
  home.file."dev/work/.env".text = ''
    BROWSER=firefox-work
  '';
}
