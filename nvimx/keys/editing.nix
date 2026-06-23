{
  keymaps = [
    # yank/paste uses system clipboard ("+) if no register specified
    {
      key = "y";
      action = ''v:lua.clipboard_or_default("y")'';
      mode = [
        "n"
        "x"
      ];
      options.noremap = true;
      options.expr = true;
    }
    {
      key = "Y";
      action = ''v:lua.clipboard_or_default("Y")'';
      mode = [
        "n"
        "x"
      ];
      options.noremap = true;
      options.expr = true;
    }
    {
      key = "p";
      action = ''v:lua.clipboard_or_default("p")'';
      mode = [
        "n"
        "x"
      ];
      options.noremap = true;
      options.expr = true;
    }
    {
      key = "P";
      action = ''v:lua.clipboard_or_default("P")'';
      mode = [
        "n"
        "x"
      ];
      options.noremap = true;
      options.expr = true;
    }
    # move selected lines up/down while preserving indentation
    {
      key = "J";
      action = ":m '>+1<cr>gv=gv";
      mode = "v";
    }
    {
      key = "K";
      action = ":m '<-2<cr>gv=gv";
      mode = "v";
    }
    # tab / shift+tab to indent/unindent
    {
      key = "<Tab>";
      action = ">gv";
      mode = "v";
    }
    {
      key = "<S-Tab>";
      action = "<gv";
      mode = "v";
    }
    # # shift+tab uses backspace in insert mode
    # {
    #   key = "<S-Tab>";
    #   action = "<BS>"; # backspace
    #   mode = "i";
    # }
    # FIXME: esc cancel search hilight
    # {
    #   key = "<ESC>"
    #   action = 
    # }
  ];

  extraConfigLua = ''
    function clipboard_or_default(key)
      local reg = vim.v.register
      if reg ~= '"' and reg ~= "+" then
        return '"' .. reg .. key
      else
        return '"+' .. key
      end
    end
  '';
}
