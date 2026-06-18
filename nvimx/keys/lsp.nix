{
  lsp.keymaps = [
    {
      key = "gd";
      lspBufAction = "definition";
      options.desc = "LSP: Go to definition";
      mode = "n";
    }
    {
      key = "gD";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options.desc = "LSP: Open diagnostics";
      mode = "n";
    }
    {
      key = "gr";
      lspBufAction = "references";
      options.desc = "LSP: Go to references";
      mode = "n";
    }
    {
      key = "gt";
      lspBufAction = "type_definition";
      options.desc = "LSP: Go to type definition";
      mode = "n";
    }
    {
      key = "gi";
      lspBufAction = "implementation";
      options.desc = "LSP: Go to implementation";
      mode = "n";
    }
    {
      key = "gls";
      lspBufAction = "document_symbol";
      options.desc = "LSP: List document symbols";
      mode = "n";
    }
    {
      key = "gla";
      lspBufAction = "code_action";
      options.desc = "LSP: Code actions";
      mode = "n";
    }
    {
      key = "glh";
      lspBufAction = "signature_help";
      options.desc = "LSP: Signature help";
      mode = "n";
    }
    {
      key = "glr";
      lspBufAction = "rename";
      options.desc = "LSP: Rename";
      mode = "n";
    }
    {
      key = "K";
      lspBufAction = "hover";
      mode = "n";
    }
  ];

}
