{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; rec {
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
        emacs
        vim
        neovim
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
        thunderbird
        vlc
        zathura
      ];
    };
  };
}
