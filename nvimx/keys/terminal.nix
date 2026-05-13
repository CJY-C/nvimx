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
    # terminal nav
    {
      key = "<C-h>";
      action = "<C-\\><C-n><C-h>";
      mode = "t";
    }
    {
      key = "<C-j>";
      action = "<C-\\><C-n><C-j>";
      mode = "t";
    }
    {
      key = "<C-k>";
      action = "<C-\\><C-n><C-k>";
      mode = "t";
    }
    {
      key = "<C-l>";
      action = "<C-\\><C-n><C-l>";
      mode = "t";
    }
    {
      key = "<C-left>";
      action = "<C-\\><C-n><C-h>";
      mode = "t";
    }
    {
      key = "<C-down>";
      action = "<C-\\><C-n><C-j>";
      mode = "t";
    }
    {
      key = "<C-up>";
      action = "<C-\\><C-n><C-k>";
      mode = "t";
    }
    {
      key = "<C-right>";
      action = "<C-\\><C-n><C-l>";
      mode = "t";
    }
  ];
}
