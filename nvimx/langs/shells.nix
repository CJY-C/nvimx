{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.shells.enable = lib.mkEnableOption "shell";
  config = lib.mkIf (config.nvimx.preset.shells.enable) {
    nvimx.lsp.enable = true;
    lsp.servers.bashls.enable = true;
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      bash
      zsh
      fish
    ];
  };
}
