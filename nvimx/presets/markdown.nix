{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.markdown.enable = lib.mkEnableOption "markdown";

  config = lib.mkIf (config.nvimx.preset.markdown.enable) {
    nvimx.lsp.enable = true;

    plugins.lsp.servers.marksman = {
      enable = true;
    };

    plugins.render-markdown = {
      enable = true;
      settings = {
        enabled = true;
        preset = "none";
        render_modes = true;
        max_file_size = 10.0;
        debounce = 100;
        signs.enabled = false;
      };
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      markdown
      markdown_inline
    ];
  };
}
