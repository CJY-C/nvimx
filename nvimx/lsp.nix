{
  lib,
  config,
  ...
}:

{
  options.nvimx.lsp.enable = lib.mkEnableOption "lsp";

  config = lib.mkIf (config.nvimx.lsp.enable) {
    plugins.lsp = {
      enable = true;
      inlayHints = true;
    };

    extraConfigLua = ''
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-format-on-save", { clear = false }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    '';
  };
}
