{
  lib,
  config,
  ...
}:

let
  prettierFallback = {
    __unkeyed-1 = "prettierd";
    __unkeyed-2 = "prettier";
    stop_after_first = true;
  };
in
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
      typescript = prettierFallback;
      typescriptreact = prettierFallback;
      javascript = prettierFallback;
      javascriptreact = prettierFallback;
      json = prettierFallback;
    };
  };
}
