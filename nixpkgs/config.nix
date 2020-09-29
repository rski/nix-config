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
        ref = "emacs-27.1";
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
        gdb
        gcc
        go
        groovy
        nodejs-14_x

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
        entr
        exa
        fd
        fzf
        file
        git
        git-review
        gnumake
        htop
        hunspell
        hyperfine
        iotop
        ispell
        jq
        keychain
        kitty
        kubectl
        loc
        lsof
        mosh
        multimarkdown
        openssl
        protobuf
        pv
        ripgrep
        rsync
        shellcheck
        sysstat
        tmux
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
        fira-code
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
        thunderbird-bin-78
        vlc
        zathura
      ];
    };
  };
}
