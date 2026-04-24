{
  lib,
  config,
  ...
}:

{
  options.nvimx.typst.enable = lib.mkEnableOption "typst";
  config = lib.mkIf (config.nvimx.typst.enable) {
    nvimx.lsp.enable = true;

    lsp.servers.tinymist = {
      enable = true;
      activate = true;
      config = {
        settings = {
          outputPath = lib.mkDefault "$root/$dir/$name";
          exportPdf = lib.mkDefault "onType";
        };
      };
    };
    
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      typst
    ];
  };
}
