{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.markdown.enable = lib.mkEnableOption "markdown";

  config = lib.mkIf (config.nvimx.preset.markdown.enable) {
    nvimx.lsp.enable = true;

    lsp.servers.marksman = {
      enable = true;
      activate = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      markdown
      markdown_inline
    ];
  };
}
