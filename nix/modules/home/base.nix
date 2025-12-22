# Minimal shell configuration for all hosts
{ config, pkgs, ... }:

{
  home-manager.users.jon =
    { config, pkgs, ... }:
    {
      programs.bash.enable = true;
      programs.fish = {
        enable = true;
        shellInitLast = builtins.readFile ../../../shell/.config/fish/config.fish;
      };
      programs.git = {
        enable = true;
        includes = [ { path = ../../../shell/.config/git/config; } ];
      };
      programs.neovim = {
        enable = true;
        extraLuaConfig = builtins.readFile ../../../editor/.config/nvim/init.lua;
        defaultEditor = true;
      };
      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
        flags = [ "--disable-up-arrow" ];
        settings = {
          enter_accept = false;
          style = "compact";
          inline_height_shell_up_key_binding = 40;
          theme = {
            name = "autumn";
          };
          sync = {
            records = true;
          };
        };
      };

      home.stateVersion = "25.05";
    };
}
