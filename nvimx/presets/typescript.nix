{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.typescript.enable = lib.mkEnableOption "typescript";

  config = lib.mkIf (config.nvimx.preset.typescript.enable) {
    nvimx.lsp.enable = true;

    plugins.lsp.servers.ts_ls = {
      enable = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      typescript
      tsx
      javascript
    ];

    plugins.conform-nvim.settings.formatters_by_ft = {
      typescript = [ [ "prettierd" "prettier" ] ];
      typescriptreact = [ [ "prettierd" "prettier" ] ];
      javascript = [ [ "prettierd" "prettier" ] ];
      javascriptreact = [ [ "prettierd" "prettier" ] ];
      json = [ [ "prettierd" "prettier" ] ];
    };
  };
}
