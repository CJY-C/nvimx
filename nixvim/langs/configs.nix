{
  lib,
  config,
  ...
}:

{
  options.nvimx.configs = {
    enable = lib.mkEnableOption "configs";
  };

  config = lib.mkIf (config.nvimx.configs.enable) {
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      ini
      json
      kdl
      toml
      yaml
    ];
  };
}
