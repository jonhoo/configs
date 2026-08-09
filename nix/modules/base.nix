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
    dig
    file
    git
    git-lfs
    htop
    openssh
    pstree
    ripgrep
    rsync
    socat
    sudo-rs
    traceroute
    unzip
    uutils-coreutils-noprefix
    wget
    zip
  ];
}
