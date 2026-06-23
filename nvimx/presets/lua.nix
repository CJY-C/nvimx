{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.lua.enable = lib.mkEnableOption "lua";

  config = lib.mkIf (config.nvimx.preset.lua.enable) {
    nvimx.lsp.enable = true;

    plugins.lsp.servers.lua_ls = {
      enable = true;
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      lua
    ];
  };
}
