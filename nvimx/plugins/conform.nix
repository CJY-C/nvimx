{ lib, config, ... }:

{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = lib.mkIf config.nvimx.lsp.formatOnSave {
        lsp_format = "fallback";
        timeout_ms = 500;
      };
    };
  };
}
