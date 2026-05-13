{
  lib,
  config,
  ...
}:

{
  options.nvimx.lsp.enable = lib.mkEnableOption "lsp";

  config = lib.mkIf (config.nvimx.lsp.enable) {
    lsp = {
      inlayHints.enable = true;
      servers."*" = {
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
            ".envrc"
          ];
        };
      };
    };

    plugins.lspconfig.enable = true;
  };
}
