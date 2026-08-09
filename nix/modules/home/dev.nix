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

      programs.direnv = {
        enable = true;
        enableFishIntegration = true;
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
          android-tools
          ascii
          asciinema
          asciinema-agg
          ast-grep
          bash-language-server
          bcc
          cargo-dist
          chromedriver
          fzf
          geckodriver
          gh
          jaq
          llmP
          llm-agents.claude-code
          nil
          nix-tree
          pdfgrep
          pdftk
          poppler-utils
          proximity-sort
          rr
          ruff
          semgrep
          shellcheck
          sqlx-cli
          treefmt
          typst
          uv
        ];
    };
}
