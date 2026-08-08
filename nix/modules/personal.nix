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
    systemd.user.services.kbfs.wantedBy = lib.mkForce [ ];

    # firmware updates
    services.fwupd.enable = true;

    # Add audio/video groups
    users.users.jon.extraGroups = [
      "audio"
      "video"
      "docker"
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
    services.pipewire.wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-hw-volume" = false;
        "bluez5.roles" = [
          # "hsp_hs"
          # "hsp_ag"
          # "hfp_hf"
          # "hfp_ag"
          "a2dp_sink"
          "bap_sink"
        ];
      };
    };
    services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
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
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
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

    # Make uv able to execute Python (and more)
    programs.nix-ld.enable = true;

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      tex-gyre.heros
      public-sans
    ];

    # Install and configure (but do not auto-start) sshd
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "jon" ];
        MaxAuthTries = 2;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };
    systemd.services.sshd.wantedBy = lib.mkForce [ ];

    # Auto-start sway
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "jon";
        };
        default_session = initial_session;
      };
    };

    # Security for GUI session
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      swaylock.enableGnomeKeyring = true;

      # If using a display manager such as GDM
      #gdm.enableGnomeKeyring = true;
    };

    # ==========================================================================
    # Auto-unlocking the login keyring under greetd autologin
    # ==========================================================================
    #
    # `enableGnomeKeyring` above wires `pam_gnome_keyring` into both the auth
    # and session phases of the greetd PAM stack, which is all a *normal* login
    # needs: the auth phase stashes the password you typed, and the session
    # phase hands it to gnome-keyring-daemon, which creates the `login` keyring
    # on first use and unlocks it thereafter.
    #
    # That falls apart under `services.greetd.settings.initial_session`
    # (autologin, below): greetd skips PAM's auth phase entirely, because there
    # is no password to check. So `pam_gnome_keyring` only ever sees the session
    # phase, with no password stashed, and quietly starts a daemon that owns no
    # keyring at all. The symptom is not an error — it is an empty
    # ~/.local/share/keyrings and a Secret Service whose only collection is the
    # in-memory `session` one, with no `default` alias. Anything that wants to
    # *persist* a secret then fails: 1Password cannot save its two-factor token,
    # and the `secret-tool lookup` password commands in home/personal.nix have
    # nothing to look up.
    #
    # Note that sharing one password between LUKS, the user account, and the
    # keyring is not by itself enough to fix this. Nothing ever types that
    # password, so nothing ever reaches PAM.
    #
    # `pam_fde_boot_pw` closes the gap. systemd-cryptsetup in the initrd caches
    # the FDE passphrase in root's kernel keyring under the name "cryptsetup";
    # this module reads it back during the *session* phase and stashes it in the
    # `gkr_system_authtok` PAM item, which is exactly where `pam_gnome_keyring`
    # looks. gnome-keyring then creates the `login` keyring with that passphrase
    # on the next boot and unlocks it on every subsequent one, with no prompt.
    #
    # This is not something an upstream NixOS option is about to make redundant.
    # The obvious candidate, nixpkgs#286587, is GDM-specific and builds on
    # `pam_systemd_loadkey`, which reads the key during the auth phase — the
    # phase greetd does not run. Any eventual upstream fix for greetd has to be
    # session-phase, i.e. it has to do what this module does. Revisit if
    # `security.pam.services.<name>` ever grows a session-phase key injector.
    security.pam.services.greetd.rules.session.fde_boot_pw = {
      # Must precede `pam_gnome_keyring` (order 12600), which consumes the item
      # this module sets.
      order = 12500;
      control = "optional";
      modulePath = "${pkgs.pam_fde_boot_pw}/lib/security/pam_fde_boot_pw.so";
      args = [ "inject_for=gkr" ];
    };

    # The kernel keyring `pam_fde_boot_pw` reads only gets populated by
    # systemd-cryptsetup, so systemd-in-initrd is a hard prerequisite. It
    # defaults to true, which makes it easy to lose by accident.
    assertions = [
      {
        assertion = config.boot.initrd.systemd.enable;
        message = "pam_fde_boot_pw needs systemd in the initrd to cache the LUKS passphrase in the kernel keyring";
      }
    ];

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      aria2
      cifs-utils
      ffmpeg-full
      poppler-utils
      fontforge-fonttools
      pv
    ];
  };
}
