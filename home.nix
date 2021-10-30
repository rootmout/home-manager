{ config, pkgs, ... }:

let shellAliases = { };
in {
  imports = [ ./terminal.nix ./ssh.nix ];

  nixpkgs.config.allowUnfree = true;

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

  programs.bash = {
    enable = true;
    inherit shellAliases;
  };

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
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
