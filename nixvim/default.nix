{
  pkgs,
  nixvim,
  system,
  lib,
  stdenv,
  ...
}:

{
  imports = [
    ./keys.nix
    ./langs
    ./plugins
  ];
  enableMan = false;

  colorschemes.onedark = {
    enable = true;
    settings = {
      style = "cool";
    };
  };

  globals = {
    mapleader = "\\"; # enter
  };

  opts = {
    mouse = "a"; # mouse support: all modes
    mousemodel = "extend"; # mouse selection
    number = true; # lineno
    cursorline = true;
    termguicolors = true;

    # indent
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;
  };

  clipboard = {
    register = "unnamedplus"; # y, p integrate w system clipboard
 };
}
