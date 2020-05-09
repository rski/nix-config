{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; rec {
    _emacs = pkgs.emacs.overrideAttrs (oldAttrs: rec {
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
      ];
    };
    networking = pkgs.buildEnv {
      name = "networking";
      paths = [
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
    myemacs = pkgs.buildEnv {
      name = "myemacs";
      paths = [ _emacs ];
    };
  };
}
