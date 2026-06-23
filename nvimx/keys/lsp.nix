{
  plugins.lsp.keymaps = {
    silent = true;
    lspBuf = {
      gd = "definition";
      gr = "references";
      gt = "type_definition";
      gi = "implementation";
      gls = "document_symbol";
      gla = "code_action";
      glh = "signature_help";
      glr = "rename";
      K = "hover";
    };
    diagnostic = {
      gD = "open_float";
    };
  };
}
