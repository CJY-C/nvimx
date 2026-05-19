{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.configs = {
    enable = lib.mkEnableOption "configs";
  };

  config = lib.mkIf (config.nvimx.preset.configs.enable) {
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      ini
      json
      kdl
      toml
      yaml
    ];
  };
}
