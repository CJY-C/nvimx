{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.latex.enable = lib.mkEnableOption "latex";
  config = lib.mkIf (config.nvimx.preset.latex.enable) {
    nvimx.lsp.enable = true;
    lsp.servers.texlab = {
      enable = true;
      activate = true;
      config.settings = {
        texlab = {
          build.onSave = true; # build with latexmk
          chktex.onEdit = true; # lint with chktex
        };
      };
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      latex
    ];
  };
}
