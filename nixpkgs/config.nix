{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; rec {
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
        caffeine-ng
        colordiff
        lsof
        loc
        multimarkdown
        unzip
        vlc

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

        rustup
        python27Packages.python-language-server
      ];
    };
    tools = pkgs.buildEnv {
      name = "tools";
      paths = [
        bat
        fd
        fzf
        git
        gnumake
        htop
        hunspell
        iotop
        intel-gpu-tools
        ispell
        jq
        keychain
        kubectl
        mosh
        openssl
        pasystray
        pavucontrol
        protobuf
        ripgrep
        scrot
        shellcheck
        sysstat
        tree
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
        cbatticon
        clementine
        discord
        firefox
        gimp
        gnome3.cheese
        gnome3.eog
        i3lock
        lshw
        pcmanfm
        picom
        spotify
        tdesktop
        thunderbird
        zathura
      ];
    };
  };
}
