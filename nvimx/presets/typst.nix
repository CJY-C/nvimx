{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.typst.enable = lib.mkEnableOption "typst";
  config = lib.mkIf (config.nvimx.preset.typst.enable) {
    nvimx.lsp.enable = true;

    plugins.lsp.servers.tinymist = {
      enable = true;
      settings = {
        outputPath = lib.mkDefault "$root/$dir/$name";
        exportPdf = lib.mkDefault "onType";
      };
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      typst
    ];
  };
}
