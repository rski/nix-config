let
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/a06fda4c5d9d13b3aa7245ae885b2047482ecf4f.tar.gz) {};
in
{
  allowUnfree = true;
  packageOverrides = pkgs: with unstable; rec {
    _emacs = (pkgs.emacs.override { srcRepo = true; }).overrideAttrs(oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--program-transform-name=s/^ctags/ctags.emacs/"
      ];
      buildInputs = oldAttrs.buildInputs ++ [
        jansson harfbuzz git
      ];
      srcRepo = true;
      src = fetchGit {
        url = "https://github.com/emacs-mirror/emacs";
        ref = "emacs-27.0.91";
      };
      patches = [];
      postPatch = "";
    });
    all = pkgs.buildEnv {
      name = "all";
      paths = [
        networking
        proglangs
        tools
        editors
        de
      ];
    };
    networking = pkgs.buildEnv {
      name = "networking";
      paths = [
        dnsutils
        mtr
        sshpass
        traceroute
        wget
      ];
    };
    proglangs = pkgs.buildEnv {
      name = "proglangs";
      paths = [
        maven3
        clang-tools
        gcc
        go
        groovy

        mypy
        python27Packages.pylint
        python2
        python3
        python-language-server

        cargo
        rust-analyzer
      ];
    };
    tools = pkgs.buildEnv {
      name = "tools";
      paths = [
        bandwhich
        bat
        colordiff
        fd
        fzf
        git
        gnumake
        htop
        hunspell
        hyperfine
        iotop
        ispell
        jq
        keychain
        kubectl
        loc
        lsof
        mosh
        multimarkdown
        openssl
        protobuf
        ripgrep
        shellcheck
        sysstat
        tree
        unzip
      ];
    };
    editors = pkgs.buildEnv {
      name = "editors";
      paths = [
        vim
        neovim
      ];
    };
    myemacs = pkgs.buildEnv {
      name = "myemacs";
      paths = [
        _emacs
      ];
    };
    de = pkgs.buildEnv {
      name = "de";
      paths = [
        arandr
        arc-icon-theme
        caffeine-ng
        cbatticon
        clementine
        discord
        firefox
        gimp
        gnome3.cheese
        gnome3.eog
        i3lock
        intel-gpu-tools
        lshw
        lxqt.lxqt-notificationd
        pasystray
        pavucontrol
        pcmanfm
        picom
        screenkey
        scrot
        spotify
        tdesktop
        thunderbird
        vlc
        zathura
      ];
    };
  };
}
