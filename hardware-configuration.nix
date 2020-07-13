{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "nvme" "usb_storage" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = pkgs.linuxPackages_5_7;
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/387ccc52-0b22-45c8-b959-ea91043765d9";

  fileSystems."/boot" =
   { device = "/dev/disk/by-uuid/128F-061A";
      fsType = "vfat";
    };

  fileSystems."/" = 
     {
       device= "/dev/disk/by-uuid/0e72e56f-99c7-48b7-a9cf-7c4c0b17f1ba";
       fsType = "ext4";
     };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/13225e6f-38f3-4d60-b0e7-d281125d8c40"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
