# Personal workstation user configuration (email, dev tools)
{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
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

      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
      };

      home.packages = with pkgs; [
        aria2
        ast-grep
        backblaze-b2
        bat
        cargo-expand
        cargo-hack
        cargo-insta
        cargo-machete
        cargo-msrv
        cargo-nextest
        cargo-outdated
        eza
        fzf
        kbfs
        keybase
        nil
        nix-tree
        poppler-utils
        proximity-sort
        ruby
        rustup
        semgrep
        shellcheck
        treefmt
        urlscan
        valgrind
      ];
    };
}
