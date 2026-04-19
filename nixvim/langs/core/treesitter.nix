{
  lib,
  config,
  ...
}:

{
  options.nvimx.treesitter.enable = lib.mkEnableOption "treesitter";

  config = lib.mkIf (config.nvimx.treesitter.enable) { 
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
      nixGrammars = true;
      nixvimInjections = true;
    };
  
    plugins.treesitter-context = {
      enable = true;
      settings = {
        max_lines = 2;
      };
    };
    
    opts = {
      # fold
      foldlevel = 99;
      foldlevelstart = 90;
    };

    dependencies.tree-sitter.enable = true;
  };
}
