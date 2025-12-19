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

      home.stateVersion = "25.05";
    };
}
