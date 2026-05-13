{ ... }:

{
  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = true;
    settings = {
      completion = {
        documentation.auto_show = true;
      };
      sources.default = [ "lsp" "path" "snippets" ]; # removed "buffer" text completion
      keymap.preset = "super-tab";
      signature.enabled = true;
    };
  };
}
