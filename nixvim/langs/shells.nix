{
  lib,
  config,
  ...
}:

{
  options.nvimx.shells.enable = lib.mkEnableOption "shell";
  config = lib.mkIf (config.nvimx.shells.enable) {
    nvimx.lsp.enable = true;
    lsp.servers.bashls.enable = true;

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      bash
      zsh
      fish
    ];
  };
}
