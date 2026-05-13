{
  lsp.keymaps = [
    {
      key = "gd";
      lspBufAction = "definition";
      options.desc = "LSP: Go to definition";
    }
    {
      key = "gD";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options.desc = "LSP: Open diagnostics";
    }
    {
      key = "gr";
      lspBufAction = "references";
      options.desc = "LSP: Go to references";
    }
    {
      key = "gt";
      lspBufAction = "type_definition";
      options.desc = "LSP: Go to type definition";
    }
    {
      key = "gi";
      lspBufAction = "implementation";
      options.desc = "LSP: Go to implementation";
    }
    {
      key = "gls";
      lspBufAction = "document_symbol";
      options.desc = "LSP: List document symbols";
    }
    {
      key = "gla";
      lspBufAction = "code_action";
      options.desc = "LSP: Code actions";
    }
    {
      key = "gls";
      lspBufAction = "signature_help";
      options.desc = "LSP: Code actions";
    }
    {
      key = "glr";
      lspBufAction = "rename";
      options.desc = "LSP: Rename";
    }
    {
      key = "K";
      lspBufAction = "hover";
    }
  ];

}
