{ pkgs, ... }:

with pkgs;
let
  default-python = python3.withPackages (python-packages:
    with python-packages; [
      pip
      black
      flake8
      setuptools
      wheel
      twine
      flake8
      virtualenv
    ]);

in {
  home.packages = with pkgs; [
    # MISC
    cachix
    appimage-run
    appimagekit
    arandr
    haskellPackages.network-manager-tui
    tmate

    # TERMINAL
    any-nix-shell
    gotop
    htop
    neofetch
    cava
    zip
    unrar
    unzip
    escrotum
    tree
    gnupg
    aria2
    imagemagick
    feh

    # DEVELOPMENT
    idea.idea-ultimate
    nixfmt
    default-python
    conda
    #TODO adoptopenjdk-hotspot-bin-16
    gradle
    gcc
    m4
    gnumake
    binutils
    gdb
    rustup

    # SYSADMIN
    #(callPackage ./termius.nix { })
    remmina

    # BLOCKCHAIN
    (callPackage ./crypto-org-wallet.nix { })
    (callPackage ./ledgerlive.nix { })
    (callPackage ./ganache.nix { })
    monero-gui

    # OFFICE
    texlive.combined.scheme-medium
    wpsoffice
    todoist-electron
    libreoffice-fresh
    aseprite-unfree
    brave

    # DEFAULT
    pavucontrol
    (callPackage ./sigma-file-explorer.nix { })
    kotatogram-desktop
    signal-desktop
    discord
    vlc
    spotify
    blueman
    wineWowPackages.stable
    obs-studio

    # GAMES
    minecraft
  ];

}
