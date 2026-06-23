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

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      markdown
      markdown_inline
    ];
  };
}
