# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "belauensis";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  networking.interfaces.wwp0s20f0u6i12.useDHCP = true;

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
    ansible
    desktop_file_utils
    fish
    firefox
    google-chrome
    gnupg
    graphviz
    hexchat
    networkmanager
    networkmanager_vpnc
    networkmanagerapplet
    ntfs3g
    shared_mime_info

    throttled
    thunderbird

    zsh
    gvfs
  ];


  networking.networkmanager.enable = true;
  services.throttled.enable = true;

  programs.java.enable = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    # this is the pulseaudio build with bluetooth support
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
    ";
  services.blueman.enable = true;


  services.xserver.enable = true;
  services.xserver.layout = "gb,el";
  services.xserver.xkbOptions = "ctrl:nocaps, grp:rctrl_toggle";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.windowManager.awesome.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  environment.etc."xdg/gtk-3.0/settings.ini" =
    {
      text =
        ''
            [Settings]
            gtk-icon-theme-name=Arc
            gtk-theme-name=Arc
        '';
    };

  environment.homeBinInPath = true;
  environment.variables = {
    ALTERNATE_EDITOR = "";
    PATH = "$HOME/go/bin";
    # no idea why this is on by default
    CGO_ENABLED = "0";
  };

  programs.fish.enable = true;
  users.users.rski = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.fish;
  };
  users.mutableUsers = true;
  nix.trustedUsers = [ "root" "rski" ];

  nix.useSandbox = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
  users.users.root.initialHashedPassword = "";

  nix.gc.automatic = true;
  nix.gc.dates = "12:15";

  services.udisks2.enable = true;
  virtualisation.docker.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
}
