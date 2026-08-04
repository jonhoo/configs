# Host configuration for xfw (FW laptop)
{ pkgs, nixos-hardware, ... }:

{
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-intel-core-ultra-series3
    ../../modules/personal.nix
    ../../modules/laptop.nix
  ];

  networking.hostName = "xfw";

  # Boot configuration (host-specific: disk layout, encryption)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 16;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Intel-specific graphics drivers
  hardware.graphics.extraPackages = with pkgs; [
    # intel-compute-runtime-legacy1
    intel-vaapi-driver
    libva-vdpau-driver
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    model = "pc101";
    variant = "altgr-intl,euro";
  };
  home-manager.users.jon.wayland.windowManager.sway.config.input."type:keyboard" = {
    xkb_layout = "us";
    xkb_model = "pc101";
    xkb_variant = "altgr-intl,euro";
  };

  # Firewall
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
