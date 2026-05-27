{
  lib,
  config,
  ...
}:

{
  options.nvimx.preset.latex.enable = lib.mkEnableOption "latex";
  config = lib.mkIf (config.nvimx.preset.latex.enable) {
    nvimx.lsp.enable = true;
    lsp.servers.texlab = {
      enable = true;
      activate = true;
      config.settings = {
        texlab = {
          build.onSave = true; # build with latexmk
          chktex.onEdit = true; # lint with chktex
        };
      };
    };

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      latex
    ];

    # remove treesitter indent as it conflicts with neovim builtin (indent/tex.vim)
    autoCmd = [{
      desc = "disables treesitter autoindent for latex";
      event = "FileType";
      pattern = "tex";
      # runs after the treesitter * autocmd
      callback = { __raw = ''
        function(args)
          vim.bo[args.buf].indentexpr = "GetTeXIndent()"
        end
      '';};
    }];
  };
}
