{
  lib,
  config,
  ...
}:

{
  options.nvimx.treesitter = {
    enableAllGrammars = lib.mkEnableOption "all treesitter grammars";
  };

  config = {
    plugins.treesitter = {
      enable = true;
      grammarPackages = 
        if config.nvimx.treesitter.enableAllGrammars
          then config.plugins.treesitter.package.allGrammars
          else [];
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
