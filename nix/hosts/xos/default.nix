# Host configuration for xos (X1C laptop)
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/personal.nix
    ../../modules/laptop.nix
  ];

  networking.hostName = "xos";

  # Boot configuration (host-specific: disk layout, encryption)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 16;
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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
  };

  # Firewall
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
