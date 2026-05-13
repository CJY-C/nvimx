_:

{
  plugins.git-conflict = {
    enable = true;
  };

  keymaps = [{
    action = "<cmd>GitConflictListQf<CR>";
    key = "<leader>gc";
    options.desc = "Git: List merge conflicts";
  }];
}
