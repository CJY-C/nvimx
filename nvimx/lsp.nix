{
  lib,
  config,
  ...
}:

{
  options.nvimx.lsp = {
    enable = lib.mkEnableOption "lsp";
    formatOnSave = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic format-on-save.";
    };
  };

  config = lib.mkIf (config.nvimx.lsp.enable) {
    plugins.lsp = {
      enable = true;
      inlayHints = true;
    };
  };
}
