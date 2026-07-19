{ ... }:

{
  plugins.diffview = {
    enable = true;
  };

  keymaps = [
    {
      action = "<cmd>DiffviewOpen<CR>";
      key = "<leader>gd";
      options.desc = "Diffview: Open";
    }
    {
      action = "<cmd>DiffviewClose<CR>";
      key = "<leader>gq";
      options.desc = "Diffview: Close";
    }
    {
      action = "<cmd>DiffviewFileHistory %<CR>";
      key = "<leader>gh";
      options.desc = "Diffview: Current file history";
    }
  ];
}
