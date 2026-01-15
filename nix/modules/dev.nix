# Development environment (for remote dev hosts)
{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./home/dev.nix
  ];

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
    nixfmt-rfc-style
    nodejs
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
