# Help is available in the configuration.nix(5) man page
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

  networking.hostName = "nauticus";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  time.timeZone = "Europe/Athens";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    emacs
    chromium
    deluge
    git
    gnumake
    scrot
    vim
    gnome3.gnome_terminal
    pcmanfm
    hexchat
    # pulse
    pasystray
    pulseaudioLight
    pavucontrol
    # AV
    clementine
    smplayer
    mpv

    arc-icon-theme
    # thumbnails
    xfce.tumbler
    ffmpegthumbnailer

    zathura
    unzip

    # default applications in file manager and such
    shared_mime_info
    desktop_file_utils

    # needed for qdbus to control clementine
    qt5.qttools

    # nix dev
    nix-prefetch-git

    gnuplot
   (wine.override {
      wineRelease = "staging";
      openglSupport = true;
      pulseaudioSupport = true;
    })
  ];
  # TODO figure out how to set these for gtk2
  environment.etc."xdg/gtk-3.0/settings.ini" =
        {
            text =
                ''
                    [Settings]
                    gtk-icon-theme-name=Arc
                    gtk-theme-name=Arc
                '';
        };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "uk";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  # :(
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  services.compton = {
    enable = true;
    backend = "glx";
    vSync = "opengl-swc";
    extraOptions = "paint-on-overlay = true;\n";
  };

  hardware.pulseaudio.enable = true;

  # subject to change
  fileSystems."/data" =
  { device = "/dev/sdb3"; };

  # enable trim for devices that support it
  systemd.services.fstrim = {
    startAt = "18:00";
    description = "Trim SSD";
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.utillinux}/bin/fstrim -a -v";
  };

  users.extraUsers.rski = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    password = "hunter2";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
