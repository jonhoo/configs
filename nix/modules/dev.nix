# Development environment (for remote dev hosts)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./base.nix
    ./home/dev.nix
  ];

  # Configure Docker, but don't auto-start it.
  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ];

  environment.systemPackages = with pkgs; [
    bpftrace
    cargo-expand
    cargo-hack
    cargo-insta
    cargo-machete
    cargo-msrv
    cargo-nextest
    cargo-outdated
    cpuset
    chromedriver
    gcc
    gdb
    gnumake
    hunspell
    hunspellDicts.en_GB-ize
    hunspellDicts.nb_NO
    hyperfine
    inferno
    jujutsu
    kdePackages.kcachegrind
    links2
    llvm
    nixfmt
    nodejs
    patchelf
    perf
    python3
    ruby
    rustup
    tcpdump
    valgrind
    xxd
  ];

  home-manager.useGlobalPkgs = true;
}
