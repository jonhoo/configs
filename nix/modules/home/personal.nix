# Personal user configuration (GUI + personal services)
{
  config,
  pkgs,
  llm-agents,
  ...
}:

{
  imports = [
    ./dev.nix
  ];

  home-manager.users.jon =
    { config, pkgs, ... }:
    {
      # Email
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
      programs.msmtp.enable = true;
      programs.neomutt = {
        enable = true;
        extraConfig = builtins.readFile ../../../mail/.muttrc;
      };
      home.file.".mailcap" = {
        source = ../../../mail/.mailcap;
      };

      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
        flags = [ "--disable-up-arrow" ];
        settings = {
          enter_accept = false;
          style = "compact";
          inline_height_shell_up_key_binding = 40;
          theme = {
            name = "autumn";
          };
          sync = {
            records = true;
          };
        };
      };

      # GUI configuration
      home.sessionVariables = {
        BROWSER = "firefox";
        XCURSOR_SIZE = "48";
        GDK_BACKEND = "wayland,x11";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XWAYLAND_DPI = "192";
      };
      home.file.".Xresources".text = ''
        Xft.dpi: 192
      '';

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "application/xps" = [ "org.pwmt.zathura.desktop" ];
          "application/vnd.ms-xpsdocument" = [ "org.pwmt.zathura.desktop" ];
          "image/gif" = [ "imv.desktop" ];
          "image/jpeg" = [ "imv.desktop" ];
          "image/jpg" = [ "imv.desktop" ];
          "image/png" = [ "imv.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "text/html" = [ "firefox.desktop" ];
          "text/plain" = [ "nvim.desktop" ];
        };
      };

      programs.alacritty = {
        enable = true;
        settings =
          let
            toml = builtins.readFile ../../../gui/.config/alacritty/alacritty.toml;
          in
          builtins.fromTOML toml;
      };
      programs.fish.loginShellInit = ''
        if test (tty) = "/dev/tty1"; and test -z "$WAYLAND_DISPLAY"; and test -n "$XDG_VTNR"; and test "$XDG_VTNR" -eq 1
          if sway
            exit 0
          end
        end
      '';
      programs.firefox.enable = true;
      programs.rofi = {
        enable = true;
        plugins = with pkgs; [ rofi-calc ];
      };
      programs.swaylock.enable = true;
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
        style = builtins.readFile ../../../gui/.config/waybar/style.css;
      };

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 16;
        gtk.enable = true;
        sway.enable = true;
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            text-scaling-factor = 0.75;
          };
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        xwayland = true; # for 1password
        wrapperFeatures.gtk = true;
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
          keybindings = { };
          modes = { };
        };
        extraConfigEarly =
          let
            inherit (config.wayland.windowManager.sway.config)
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
        extraConfig = builtins.readFile ../../../gui/.config/sway/config;
      };

      services.mako = {
        enable = true;
        settings = {
          font = "Public Sans 13";
          background-color = "#222222";
          text-color = "#d5c4a1";
          border-color = "#555555";
          "urgency=low" = {
            background-color = "#2c2826";
            text-color = "#b6aca4";
          };
          "urgency=critical" = {
            text-color = "#ebdbb2";
            border-color = "#fb4934";
          };
        };
      };

      home.packages = with pkgs; [
        # Personal tools
        backblaze-b2
        kbfs
        keybase
        urlscan

        # GUI apps
        appimage-run
        google-chrome
        (rWrapper.override {
          packages = with rPackages; [
            tidyverse
            svglite
          ];
        })
        grim
        imv
        libnotify
        libreoffice-still
        libsecret
        marp-cli
        mpv
        obsidian
        pavucontrol
        playerctl
        pulseaudio
        slurp
        swaybg
        wev
        wl-clipboard
        wlr-randr
        wmctrl
        wtype
        zathura
      ];
    };
}
