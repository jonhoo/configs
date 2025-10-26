# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix

    # Home Manager!
    <home-manager/nixos>
  ];

  # Yeah Yeah
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 7;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Encrypted root partition.
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
  # /boot and swapon are mounted in hardware-configuration.nix

  # Auto-login is fine with FDE.
  services.getty = {
    autologinUser = "jon";
    autologinOnce = true;
  };

  # The Internet!
  networking.hostName = "xos";
  networking.networkmanager.enable = true;

  # Graphics
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime-legacy1
    intel-vaapi-driver
    vaapiVdpau
  ];

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

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # No X11 please.
  services.xserver.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable screen sharing.
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

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jon = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "adm"
      "audio"
      "networkmanager"
      "users"
      "video"
      "wheel"
    ];
  };

  # Basic programs
  programs.fish.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../shell/.tmux.conf;
  };

  environment.variables = {
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.jon =
    { pkgs, ... }:
    {
      home.sessionVariables = {
        BROWSER = "firefox";
      };

      programs.alacritty = {
        enable = true;
        settings =
          let
            toml = builtins.readFile ../gui/.config/alacritty/alacritty.toml;
          in
          builtins.fromTOML toml;
      };
      programs.bash.enable = true;
      programs.fish = {
        enable = true;
        loginShellInit = ''
          if test (tty) = "/dev/tty1"; and test -z "$WAYLAND_DISPLAY"; and test -n "$XDG_VTNR"; and test "$XDG_VTNR" -eq 1
            exec sway
          end
        '';
        shellInitLast = builtins.readFile ../shell/.config/fish/config.fish;
      };
      programs.firefox.enable = true;
      programs.git = {
        enable = true;
        extraConfig = builtins.readFile ../shell/.config/git/config;
      };
      accounts.email = {
        maildirBasePath = "${config.home.homeDirectory}/.mail";
        accounts = {
          tsp = {
            primary = true;
            flavor = "fastmail.com";
            address = "jon@thesquareplanet.com";
            userName = "jon@thesquareplanet.com";
            aliases = [ "jon@tsp.io" ];
            realName = "Jon Gjengset";
            passwordCommand = "secret-tool lookup email jon@thesquareplanet.com";
            folders = {
              sent = "Sent Items";
            };
            neomutt = {
              enable = true;
              mailboxType = "imap";
            };
            msmtp = {
              enable = true;
            };
          };
          rustfm = {
            address = "hello@rustacean-station.org";
            userName = "jon@rustacean-station.org";
            realName = "Jon Gjengset";
            passwordCommand = "secret-tool lookup email jon@rustacean-station.org";
            smtp = {
              host = "smtp.improvmx.com";
            };
            msmtp = {
              enable = true;
            };
          };
        };
      };
      programs.msmtp = {
        enable = true;
      };
      programs.neomutt = {
        enable = true;
        extraConfig = builtins.readFile ../mail/.muttrc;
      };
      programs.neovim = {
        enable = true;
        extraLuaConfig = builtins.readFile ../editor/.config/nvim/init.lua;
        defaultEditor = true;
      };
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        plugins = with pkgs; [
          # https://discourse.nixos.org/t/rofi-calc-not-working-with-rofi-wayland/51301
          (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
        ];
      };
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            position = "bottom";
            modules-left = [
              "clock"
              "sway/workspaces"
              "sway/mode"
            ];
            modules-center = [ "sway/window" ];
            modules-right = [
              # "tray"
              "cpu"
              "network"
              "battery"
            ];
            "clock" = {
              format = "{:%a %d %H:%M}";
              on-click = "date -I seconds | wl-copy -n";
              tooltip-format = "{:%A, %B %e %Y, week %V, at %T}";
            };
            "network" = {
              format-wifi = "{essid} ({signalStrength}%)";
              format-ethernet = "{ipaddr}";
            };
          };
        };
        style = builtins.readFile ../gui/.config/waybar/style.css;
      };
      wayland.windowManager.sway = {
        enable = true;
        xwayland = true; # for 1password
        config = rec {
          terminal = "alacritty";
          modifier = "Mod4";
          left = "h";
          down = "j";
          up = "k";
          right = "l";
          menu = "rofi -show drun";
          bars = [
            { command = "waybar"; }
          ];
          startup = [
            { command = "firefox"; }
          ];
          input = {
            "type:keyboard" = {
              xkb_options = "ctrl:nocaps,compose:rctrl";
            };
          };
          output = {
            "eDP-1" = {
              scale = "0";
              bg =
                let
                  img = builtins.fetchurl {
                    url = "https://images.pexels.com/photos/21706244/pexels-photo-21706244.jpeg?cs=srgb&dl=pexels-dane-amacher-1175058986-21706244.jpg&fm=jpg";
                    name = "pexels-photo-21706244.jpeg";
                    sha256 = "0d8s51k0975flcmi82r7606s4w7n4hmbj5w46iy4frwgazmpn76r";
                  };
                in
                "${img} fill";
            };
          };
          # things managed by the extraConfig file:
          keybindings = { };
          modes = { };
        };
        extraConfigEarly =
          let
            inherit (config.home-manager.users.jon.wayland.windowManager.sway.config)
              modifier
              left
              down
              up
              right
              menu
              terminal
              ;
          in
          ''
            set $mod ${modifier}
            set $term ${terminal}
            set $left ${left}
            set $down ${down}
            set $up ${up}
            set $right ${right}
            set $menu ${menu}
          '';
        extraConfig = builtins.readFile ../gui/.config/sway/config;
        extraSessionCommands = ''
          export GDK_SCALE=1.5;
          export GDK_DPI_SCALE=0.75;
        '';
      };

      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
      };

      home.packages = with pkgs; [
        _1password-gui
        ast-grep
        bat
        cargo-expand
        cargo-hack
        cargo-insta
        cargo-machete
        cargo-msrv
        cargo-nextest
        cargo-outdated
        claude-code
        eza
        fzf
        grim
        imv
        libsecret
        mpv
        nil
        proximity-sort
        renpy
        rust-analyzer
        semgrep
        shellcheck
        slurp
        swaybg
        treefmt
        typst
        valgrind
        wev
        wl-clipboard
        wlr-randr
        zathura
      ];

      home.stateVersion = "25.05";
    };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    bc
    fd
    ffmpeg-full
    gdb
    git
    jq
    jujutsu
    nixfmt-rfc-style
    openssh
    ripgrep
    rsync
    socat
    sudo-rs
    uutils-coreutils-noprefix
    wget
  ];

  # Fonts!
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    public-sans
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
