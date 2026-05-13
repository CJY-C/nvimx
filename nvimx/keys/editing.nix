{
  keymaps = [
    # move selected lines up/down while preserving indentation
    {
      key = "J";
      action = ":m '>-2<cr>gv=gv";
      mode = "v";
    }
    {
      key = "K";
      action = ":m '>+1<cr>gv=gv";
      mode = "v";
    }
    # tab / shift+tab to indent/unindent
    {
      key = "<Tab>";
      action = "<C-t>";
      mode = "i";
    }
    {
      key = "<S-Tab>";
      action = "<C-d>";
      mode = "i";
    }
  ];
}
