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
        clang-tools
        colordiff
        lsof
        multimarkdown
        neovim
        unzip
        vlc
        vscode

        networking
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
    myemacs = pkgs.buildEnv {
      name = "myemacs";
      paths = [ _emacs ];
    };
  };
}
