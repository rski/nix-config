# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
  version = 2;
  device = "/dev/sda";
  enable = true;
  useOSProber = true;
  efiSupport  = true;
  };
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
    # system
    os-prober
    ntfs3g

    #development
    emacs
    git
    vim
    gnumake
    gnome3.gnome_terminal
    gnuplot

    #userspace
    chromium
    deluge
    scrot
    pcmanfm
    hexchat
    arc-icon-theme
    zathura
    unzip
    (wine.override {
       wineRelease = "staging";
       openglSupport = true;
       pulseaudioSupport = true;
     })

    # pulse
    pasystray
    pulseaudioLight
    pavucontrol

    # AV
    clementine
    smplayer
    mpv

    # thumbnails
    xfce.tumbler
    ffmpegthumbnailer

    # default applications in file manager and such
    shared_mime_info
    desktop_file_utils

    # needed for qdbus to control clementine
    qt5.qttools

    # nix dev
    nix-prefetch-git

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
  services.xserver.layout = "gb";

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
  services.udev.extraRules = "ATTR{idVendor}==\"22b8\", ATTR{idProduct}==\"2e82\", SYMLINK+=\"libmtp\",  MODE=\"0666\", ENV{ID_MTP_DEVICE}=\"1\"\n";

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
