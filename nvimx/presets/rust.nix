{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.rust.enable = lib.mkEnableOption "rust";

  config = lib.mkIf (config.nvimx.preset.rust.enable) {
    nvimx.lsp.enable = true;

    plugins.lsp.servers.rust_analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      rust
    ];
  };
}
