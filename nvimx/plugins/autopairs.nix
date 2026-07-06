{ lib, ... }:

{
  plugins.nvim-autopairs = {
    enable = lib.mkDefault true;
    settings = {
      disable_filetype = lib.mkDefault [
        "TelescopePrompt"
        "spectre_panel"
      ];
      check_ts = lib.mkDefault true;
      map_cr = lib.mkDefault true;
      map_bs = lib.mkDefault true;
    };
  };
}
