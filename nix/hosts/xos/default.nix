# Host configuration for xos (laptop)
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/graphical.nix
    ../../modules/laptop.nix
  ];

  networking.hostName = "xos";

  # Boot configuration (host-specific: disk layout, encryption)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Encrypted root partition
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "cryptd"
  ];
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-label/NixOS";
    allowDiscards = true;
  };
  fileSystems."/" = {
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };

  # Intel-specific graphics drivers
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime-legacy1
    intel-vaapi-driver
    libva-vdpau-driver
  ];

  # Firewall
  networking.firewall.enable = false;

  system.stateVersion = "25.05";
}
