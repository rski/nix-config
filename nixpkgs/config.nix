{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; rec {
    _emacs = (pkgs.emacs.override { srcRepo = true; }).overrideAttrs (oldAttrs: {
      configureFlags = (oldAttrs.configureFlags or [ ]) ++ [
        "--program-transform-name=s/^ctags/ctags.emacs/"
      ];
      buildInputs = oldAttrs.buildInputs ++ [
        jansson
        harfbuzz
        git
      ];
      srcRepo = true;
      nativeComp = true;
      src = fetchGit {
        url = "https://github.com/emacs-mirror/emacs";
        ref = "feature/native-comp";
      };
      patches = [ ];
    });
    _mygopls = buildGoModule rec {
      pname = "gopls";
      version = "v0.5.3";
      src = fetchgit { rev = "gopls/v${version}"; url = "https://go.googlesource.com/tools"; sha256 = "150jg1qmdszfvh1x5fagawgc24xy19xjg9y1hq3drwy7lfdnahmq"; };
      modRoot = "gopls";
      vendorSha256 = "1s3d4hnbw0mab7njck79qmgkjn87vs4ffk44zk2qdrzqjjlqq5iv";
      doCheck = false;
    };
    _gnmi = buildGoModule rec {
      pname = "goarista";
      version = "2cb20defcd666dda6cc5d3b32c901ce7e43bb03d";
      subPackages = [ "cmd/gnmi" ];
      src = fetchFromGitHub { owner = "aristanetworks"; repo = "goarista"; rev = "${version}"; sha256 = "0ya8ddhawifmy00l7ar0crk8jxf4k3xxab7ixw4x0b9irf18q8sp"; };
      vendorSha256 = "0k5h1zmrfcplw9k5jsjvmj13ifs8qilff7f2jln51ja0ah8ycff7";
      doCheck = false;
    };

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
        mygopls
        gnmi
      ];
    };
    mygopls = pkgs.buildEnv { 
      name = "mygopls";
      paths = [ _mygopls ];
    };
    gnmi = pkgs.buildEnv { 
      name = "gnmi";
      paths = [ _gnmi ];
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
        playerctl
        picom
        screenkey
        scrot
        spotify
        tdesktop
        thunderbird-78
        vlc
        zathura
      ];
    };
  };
}
