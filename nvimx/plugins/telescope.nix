{
  ...
}:

{
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
    };

    settings = {
      defaults.mappings = {
        i = {
          "<esc>" = "close"; # esc to close telescope
        };
      };
      pickers.buffers = {
        ignore_current_buffer = true;
        sort_mru = true; # most recently used first
      };
    };

    keymaps = {
      "<leader>fw" = {
        action = "grep_string";
        options.desc = "Telescope: Find in file";
      };

      "<leader><leader>" = {
        action = "buffers";
        options.desc = "Telescope: Find buffers";
      };

      "<leader>fc" = {
        action = "commands";
        options.desc = "Telescope: Find commands";
      };

      "<leader>fk" = {
        action = "keymaps";
        options.desc = "Telescope: Find keymaps";
      };
    };

  };

  # telescope.keymaps wraps action in <cmd>Telescope ${action}<CR> 
  # and doesnt provide __raw, so we resort to global option
  keymaps = [
    {
      key = "<leader>ff";
      action.__raw = "vim.find_files_from_project_git_root";
      options.desc = "Telescope: Find files";
    }
    {
      key = "<leader>fg";
      action.__raw = "vim.live_grep_from_project_git_root";
      options.desc = "Telescope: Find in directory";
    }
  ];

  extraConfigLuaPre = ''
    -- find files from project git root with fallback
    function vim.find_files_from_project_git_root()
      local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
      end
      local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
      end
      local opts = {}
      if is_git_repo() then
        opts = {
          cwd = get_git_root(),
        }
      end
      require("telescope.builtin").find_files(opts)
    end

    -- find text from project git root with fallback
    function vim.live_grep_from_project_git_root()
	    local function is_git_repo()
		    vim.fn.system("git rev-parse --is-inside-work-tree")
    
		    return vim.v.shell_error == 0
	    end
    
	    local function get_git_root()
		    local dot_git_path = vim.fn.finddir(".git", ".;")
		    return vim.fn.fnamemodify(dot_git_path, ":h")
	    end
    
	    local opts = {}
    
	    if is_git_repo() then
		    opts = {
			    cwd = get_git_root(),
		    }
	    end
    
	    require("telescope.builtin").live_grep(opts)
    end
  '';

  dependencies.ripgrep = {
    enable = true;
    packageFallback = true;
  };
}
