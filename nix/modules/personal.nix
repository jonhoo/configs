# Personal machine configuration (GUI + personal services)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./dev.nix
    ./home/personal.nix
  ];

  options.my.screencast.output = lib.mkOption {
    type = lib.types.str;
    default = "eDP-1";
    description = "Screen output name for screen sharing";
  };

  config = {
    # Auto-login is fine with FDE
    services.getty = {
      autologinUser = "jon";
      autologinOnce = true;
    };

    # NAS
    fileSystems."/mnt/nas/jon" = {
      device = "//192.168.50.50/jon";
      fsType = "cifs";
      options =
        let
          mount_opts = "_netdev,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in
        [ "${mount_opts},credentials=/etc/nixos/smb-secrets,uid=jon,gid=users" ];
    };

    # Keybase
    services.keybase.enable = true;
    services.kbfs.enable = true;

    # Add audio/video groups
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
        output_name = config.my.screencast.output;
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

    environment.systemPackages = with pkgs; [
      aria2
      cifs-utils
      ffmpeg-full
      poppler-utils
      pv
    ];
  };
}
