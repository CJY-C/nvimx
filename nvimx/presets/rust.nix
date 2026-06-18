{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.rust.enable = lib.mkEnableOption "rust";

  config = lib.mkIf (config.nvimx.preset.rust.enable) {
    nvimx.lsp.enable = true;

    lsp.servers.rust_analyzer = {
      enable = true;
      activate = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      rust
    ];
  };
}
