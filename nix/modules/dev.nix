# Development environment (for remote dev hosts)
{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./home/dev.nix
  ];

  environment.systemPackages = with pkgs; [
    cargo-expand
    cargo-hack
    cargo-insta
    cargo-machete
    cargo-msrv
    cargo-nextest
    cargo-outdated
    cpuset
    gcc
    gdb
    gnumake
    hunspell
    hunspellDicts.en_GB-ize
    hunspellDicts.nb_NO
    jujutsu
    links2
    llvm
    nixfmt-rfc-style
    ruby
    rustup
    valgrind
  ];

  home-manager.useGlobalPkgs = true;
}
