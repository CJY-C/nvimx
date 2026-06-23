{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.python.enable = lib.mkEnableOption "python";

  config = lib.mkIf (config.nvimx.preset.python.enable) {
    nvimx.lsp.enable = true;

    plugins.lsp.servers.pyright = {
      enable = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      python
    ];
  };
}
