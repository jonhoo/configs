# Minimal system basics for ALL hosts (including headless servers)
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Oslo";

  users.users.jon = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "adm"
      "users"
      "wheel"
    ];
  };

  programs.fish.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../../shell/.tmux.conf;
  };

  environment.systemPackages = with pkgs; [
    bc
    fd
    gcc
    gdb
    git
    gnumake
    htop
    jq
    jujutsu
    llvm
    nixfmt-rfc-style
    openssh
    ripgrep
    rsync
    socat
    sudo-rs
    uutils-coreutils-noprefix
    wget
  ];
}
