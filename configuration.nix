# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Include the results of the hardware scan.
  imports = [ ./hardware-configuration.nix ];

  boot= { 
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };

  networking = {
    hostName ="belauensis";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;
    interfaces.wwp0s20f0u6i12.useDHCP = true;

    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    desktop_file_utils
    gnupg
    google-chrome
    graphviz
    gvfs
    hexchat
    home-manager
    networkmanager
    networkmanager_vpnc
    networkmanagerapplet
    ntfs3g
    shared_mime_info
    throttled
    zsh
  ];

  programs.java.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      # this is the pulseaudio build with bluetooth support
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
  };

  services = {
    blueman.enable = true;
    gnome3.gnome-keyring.enable = true;
    throttled.enable = true;
    udisks2.enable = true;
    earlyoom.enable = true;
    xserver = {
      enable = true;
      layout = "gb,el";
      xkbOptions = "ctrl:nocaps, grp:rctrl_toggle";
      # Enable touchpad support.
      libinput.enable = true;
      windowManager.awesome.enable = true;
      desktopManager.xterm.enable = false;
    };
  };

  environment = {
    etc."xdg/gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-icon-theme-name=Arc
            gtk-theme-name=Arc
        '';
    homeBinInPath = true;
    variables = {
      ALTERNATE_EDITOR = "";
      EDITOR = "nvim";
      PATH = "$HOME/go/bin";
      # no idea why this is on by default
      CGO_ENABLED = "0";
    };
  };

  users = {
    users = {
        rski = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" "docker" ];
          shell = pkgs.fish;
        };
        root.initialHashedPassword = "";
    };
    mutableUsers = true;
  };

  nix = {
    trustedUsers = [ "root" "rski" ];
    useSandbox = true;
    gc = {
      automatic = true;
      dates = "12:15";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
  virtualisation.docker.enable = true;
}
