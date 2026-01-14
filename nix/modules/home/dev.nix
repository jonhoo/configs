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

      home.packages =
        with pkgs;
        let
          llmP = llm.withPlugins {
            llm-anthropic = true;
            llm-cmd = true;
          };
        in
        [
          asciinema_3
          asciinema-agg
          ast-grep
          bash-language-server
          fzf
          llmP
          llm-agents.claude-code
          nil
          nix-tree
          pdftk
          poppler-utils
          proximity-sort
          rr
          ruff
          semgrep
          shellcheck
          treefmt
          typst
        ];
    };
}
