# Any machine with a screen - GUI system configuration
{ config, pkgs, ... }:

{
  imports = [
    ./workstation.nix
    ./home/graphical.nix
  ];

  # Add audio/video groups for graphical users
  users.users.jon.extraGroups = [
    "audio"
    "video"
  ];

  # Graphics (extraPackages are host-specific)
  hardware.graphics.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # No X11
  services.xserver.enable = false;

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Screen sharing
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = "wlr";
      };
    };
    wlr.enable = true;
    wlr.settings.screencast = {
      output_name = "eDP-1";
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };

  # Input
  services.libinput.enable = true;

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "jon" ];
  };

  programs.dconf.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    public-sans
  ];

  # Security for GUI session
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
}
