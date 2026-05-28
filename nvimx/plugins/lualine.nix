{
  ...
}:

{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true; # one status line at the bottom
        always_show_tabline = false;
      };
      sections = {
        lualine_a = [
          "mode" 
        ];
        lualine_b = [
          {
            __unkeyed-1 = "b:gitsigns_head";
            icon = { __unkeyed-1 = ""; align = "right"; };
          }
          # use gitsigns branch and diff
          {
            __unkeyed-1 = "diff";
            source.__raw = "diff_source";
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "filename"; 
            symbols = {
              modified = "[+]";
              readonly = "[-]";
              unamed = "[No Name]";
              new = "[New]";
            };
            path = 1;
          }
        ];
        lualine_x = [ "progress" "filetype" ];
        lualine_y = [ "diagnostics" ];
        lualine_z = [ "lsp_status" ];
      };
      tabline = {
        lualine_a = [{
          __unkeyed-1 = "tabs";
          mode = 2; # number + name
          max_length.__raw = "vim.o.columns * 1.2"; # set it higher to fill width
          use_mode_colors = true;
        }];
      };
    };

    luaConfig.pre = ''
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
          }
        end
      end
    '';
  };
}
