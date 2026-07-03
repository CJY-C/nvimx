{ ... }:

{
  keymaps = [
    {
      key = "<leader>u";
      action = "<cmd>packadd nvim.undotree<CR><cmd>Undotree<CR>";
      options.desc = "Undo: Tree";
    }
    {
      key = "<leader>dd";
      action = "<cmd>lua vim.nvimx_difftool_prompt()<CR>";
      options.desc = "DiffTool: Compare paths";
    }
    {
      key = "<leader>df";
      action = "<cmd>lua vim.nvimx_difftool_current_file()<CR>";
      options.desc = "DiffTool: Compare current file";
    }
  ];

  extraConfigLua = ''
    local function difftool_open(left, right)
      vim.cmd("packadd nvim.difftool")
      vim.cmd("DiffTool " .. vim.fn.fnameescape(left) .. " " .. vim.fn.fnameescape(right))
    end

    function vim.nvimx_difftool_prompt()
      vim.ui.input({ prompt = "Diff left path: ", default = vim.fn.getcwd() }, function(left)
        if not left or left == "" then
          return
        end

        vim.ui.input({ prompt = "Diff right path: ", default = vim.fn.getcwd() }, function(right)
          if not right or right == "" then
            return
          end

          difftool_open(vim.fn.expand(left), vim.fn.expand(right))
        end)
      end)
    end

    function vim.nvimx_difftool_current_file()
      local current = vim.api.nvim_buf_get_name(0)
      if current == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.WARN)
        return
      end

      vim.ui.input({ prompt = "Diff against path: ", default = vim.fn.getcwd() }, function(other)
        if not other or other == "" then
          return
        end

        difftool_open(current, vim.fn.expand(other))
      end)
    end
  '';
}
