{ inputs, self, ... }:
{
flake.nixosModules.zbookHardware = { config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-46449301-2877-4a4e-ad20-28b6d0f7c37f";
      fsType = "f2fs";
    };

  boot.initrd.luks.devices."luks-46449301-2877-4a4e-ad20-28b6d0f7c37f".device = "/dev/disk/by-uuid/46449301-2877-4a4e-ad20-28b6d0f7c37f";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/30A6-4EE9";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
};
}
