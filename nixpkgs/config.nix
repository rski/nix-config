{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; rec {
    myemacs = pkgs.emacs.overrideAttrs (oldAttrs: rec {
      configureFlags = (oldAttrs.configureFlags or []) ++ [
        "--program-transform-name=s/^ctags/ctags.emacs/"
      ];
    });
    all = pkgs.buildEnv {
      name = "all";
      paths = [
        caffeine-ng
        colordiff
        lsof
        multimarkdown
        neovim
        unzip
        vlc
        vscode

        networking
        proglangs
        tools
        editors
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
        clang-tools
        gcc
        go
        python27Packages.pylint
        python2
        python3

        rustup
      ];
    };
    tools = pkgs.buildEnv {
      name = "tools";
      paths = [
        fd
        fzf
        git
        gnumake
        htop
        jq
        keychain
        kubectl
        mosh
        openssl
        pasystray
        pavucontrol
        ripgrep
        scrot
      ];
    };
    editors = pkgs.buildEnv {
      name = "editors";
      paths = [
        myemacs
        vim
        neovim
        vscode
      ];
    };
  };
}
