{
  keymaps = [
    # navigation
    {
      key = "<C-h>";
      action = ''<cmd>lua win_move_or_tab("h")<CR>'';
      options.desc = "Window or Tab: Go left";
    }
    {
      key = "<C-j>";
      action = "<cmd>wincmd j<CR>";
      options.desc = "Window: Go down";
    }
    {
      key = "<C-k>";
      action = "<cmd>wincmd k<CR>";
      options.desc = "Window: Go up";
    }
    {
      key = "<C-l>";
      action = ''<cmd>lua win_move_or_tab("l")<CR>'';
      options.desc = "Window or Tab: Go right";
    }
    {
      key = "<C-left>";
      action = ''<cmd>lua win_move_or_tab("h")<CR>'';
      options.desc = "Window or Tab: Go left";
    }
    {
      key = "<C-down>";
      action = "<cmd>wincmd j<CR>";
      options.desc = "Window: Go down";
    }
    {
      key = "<C-up>";
      action = "<cmd>wincmd k<CR>";
      options.desc = "Window: Go up";
    }
    {
      key = "<C-right>";
      action = ''<cmd>lua win_move_or_tab("l")<CR>'';
      options.desc = "Window or Tab: Go right";
    }
    {
      key = "<C-S-H>";
      action = "<cmd>tabprevious<CR>";
      options.desc = "Tab: Go left";
    }
    {
      key = "<C-S-L>";
      action = "<cmd>tabnext<CR>";
      options.desc = "Tab: Go right";
    }
    # window/tab
    {
      key = "<C-x>";
      action = "<cmd>lua smartclose()<CR>";
      options.desc = "Window or Tab: Close";
    }
    {
      key = "<C-t>";
      action = "<cmd>tabnew<CR>";
      options.desc = "Tab: New";
    }
    {
      key = "<leader>h";
      action = "<cmd>split<CR>";
      options.desc = "Window: Horizontal split";
    }
    {
      key = "<leader>v";
      action = "<cmd>vsplit<CR>";
      options.desc = "Window: Vertical split";
    }
  ];

  extraConfigLua = ''
    -- close window (or tab if last window)
    -- cleans up buffer if the buffer is only shown in this window
    function smartclose()
      local bufnr = vim.api.nvim_get_current_buf()

      -- Check if buffer is visible in more than just this window
      local wins_with_buf = vim.fn.win_findbuf(bufnr)
      local should_delete = #wins_with_buf <= 1
      
      local only_window_in_tab = vim.fn.winnr('$') == 1
      local only_tab = vim.fn.tabpagenr('$') == 1
      local is_terminal = vim.bo.buftype == "terminal"

      if only_window_in_tab then
        if only_tab then
          -- Can't close last tab; open an empty buffer in its place
          if should_delete then
            vim.cmd('enew')
            vim.api.nvim_buf_delete(bufnr, { force = is_terminal })
          end
        else
          -- tabclose implicitly closes the window; delete buf after
          vim.cmd('tabclose')
          if should_delete then
            vim.api.nvim_buf_delete(bufnr, { force = is_terminal })
          end
        end
      else
        vim.api.nvim_win_close(0, false)
        if should_delete then
          vim.api.nvim_buf_delete(bufnr, { force = is_terminal })
        end
      end
    end

    function win_move_or_tab(cmd_fallback)
      local win_before = vim.api.nvim_get_current_win()

      -- try window move
      vim.cmd("wincmd " .. cmd_fallback)

      local win_after = vim.api.nvim_get_current_win()

      -- if no window change happened → fallback
      if win_before == win_after then
        vim.cmd(cmd_fallback == "h" and "tabprevious" or "tabnext")
      end
    end
  '';
}
