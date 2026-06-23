{
  keymaps = [
    # terminal
    {
      key = "<leader>t";
      action = "<cmd>terminal<CR>";
    }
    {
      key = "<C-esc>";
      action = "<C-\\><C-n>";
      mode = "t";
      options.desc = "Exit to normal mode";
      options.nowait = true;
    }
    {
      key = "<C-x>";
      action = "<C-\\><C-n><cmd>bdelete!<CR>"; # cant close terminal in normal mode?
      mode = "t";
    }
  ];
}
