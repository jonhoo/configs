# Development user configuration (for remote dev hosts)
{
  config,
  pkgs,
  llm-agents,
  ...
}:

{
  imports = [
    ./base.nix
  ];

  home-manager.users.jon =
    { config, pkgs, ... }:
    {
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
      };

      home.packages = with pkgs; [
        asciinema_3
        asciinema-agg
        ast-grep
        bash-language-server
        fzf
        llm-agents.claude-code
        nil
        nix-tree
        pdftk
        poppler-utils
        proximity-sort
        ruff
        semgrep
        shellcheck
        treefmt
        typst
      ];
    };
}
