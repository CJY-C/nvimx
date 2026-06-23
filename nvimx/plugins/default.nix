{ ... }:

{
  imports = [
    ./blink-cmp.nix
    ./flash.nix
    ./git-conflict.nix
    ./grug-far.nix
    ./lualine.nix
    ./memos.nix
    ./telescope.nix
    ./yazi.nix
  ];

  plugins = {
    gitsigns.enable = true;

    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "¦";
        scope.enabled = false;
      };
    };

    nvim-surround.enable = true;

    showkeys.enable = true;

    web-devicons = {
      enable = true;
      settings = {
        color_icons = true;
        strict = true;
      };
    };

    which-key = {
      enable = true;
      settings = {
        preset = "helix";
        win.wo.winblend = 10; # 0-100, opaque to transparent
      };
    };
  };
}
