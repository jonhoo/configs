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
  programs.neovim.enable = true;
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",alacritty:Tc"
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe 'wl-copy &> /dev/null'
      bind -T copy-mode-vi Enter send-keys -X cancel
      set -sg escape-time 10
      set -g mode-keys vi
    '';
  };

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.jon =
    { pkgs, ... }:
    {
      home.sessionVariables = {
        EDITOR = "nvim";
        BROWSER = "firefox";
      };

      programs.alacritty = {
        enable = true;
        theme = "gruvbox_material_hard_dark";
        settings = {
          scrolling.history = 0;
          font.normal.family = "Noto Sans Mono";
          keyboard.bindings = [
            {
              key = "V";
              mods = "Alt";
              action = "Paste";
            }
            {
              key = "C";
              mods = "Alt";
              action = "Copy";
            }
          ];

        };
      };
      programs.bash.enable = true;
      programs.firefox.enable = true;
      programs.git = {
        enable = true;
        userName = "Jon Gjengset";
        userEmail = "jon@thesquareplanet.com";
      };
      wayland.windowManager.sway = {
        enable = true;
        config = rec {
          terminal = "alacritty";
          modifier = "Mod4";
          startup = [
            { command = "firefox"; }
          ];
          input = {
            "type:keyboard" = {
              xkb_options = "ctrl:nocaps";
            };
          };
          output = {
            eDPI = {
              scale = "0";
              # bg = "x fill";
            };
          };
          keybindings =
            let
              inherit (config.home-manager.users.jon.wayland.windowManager.sway.config) modifier menu;
            in
            lib.mkOptionDefault {
              "Print" = "exec ${pkgs.grim} --notify save screen";
              # "Shift+Print" = "exec ${pkgs.grim} --notify save area $(${xdg-user-dir} PICTURES)/$(TZ=utc date +'screenshot_%Y-%m-%d-%H%M%S.%3N.png')";
              "${modifier}+l" = "exec ${pkgs.swaylock}/bin/swaylock";
              "${modifier}+a" = "exec ${pkgs.alacritty}/bin/alacritty";
              "${modifier}+space" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun";
              "${modifier}+equal" = "exec ${pkgs.rofi-calc}/bin/rofi -show calc";
            };
        };
      };

      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
      };

      home.packages = with pkgs; [
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
        mpv
        rofi-wayland
        rofi-calc
        rust-analyzer
        semgrep
        shellcheck
        slurp
        swaybg
        treefmt
        typst
        valgrind
        wl-clipboard
        wlr-randr
        wev
      ];

      home.stateVersion = "25.05";
    };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    fd
    gdb
    git
    jq
    jujutsu
    nixfmt-rfc-style
    ripgrep
    socat
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
