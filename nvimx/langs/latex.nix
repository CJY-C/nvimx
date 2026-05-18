{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.latex.enable = lib.mkEnableOption "latex";
  config = lib.mkIf (config.nvimx.preset.latex.enable) {
    nvimx.lsp.enable = true;
    lsp.servers.texlab.enable = true;
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      latex
    ];
  };
}
