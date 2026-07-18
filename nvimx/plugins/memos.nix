{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.nvimx.memos;
  defaultEnvFile = "<nvimx-config-home>/sops-nix/secrets/rendered/memos.env";
  setupConfig = {
    host = cfg.host;
    page_size = cfg.pageSize;
    list_state = cfg.listState;
    list_order_by = cfg.listOrderBy;
    auto_save = cfg.autoSave;
    template_tag = cfg.templateTag;
    window = cfg.window;
  };
in
{
  options.nvimx.memos = {
    enable = lib.mkEnableOption "memos.nvim" // {
      default = true;
    };

    envFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = defaultEnvFile;
      description = "Runtime env file containing MEMOS_HOST and MEMOS_TOKEN.";
    };

    host = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Memos host URL. Prefer envFile for host and token together.";
    };

    pageSize = lib.mkOption {
      type = lib.types.ints.positive;
      default = 50;
      description = "Number of memos requested per page.";
    };

    listState = lib.mkOption {
      type = lib.types.str;
      default = "NORMAL";
      description = "Memos list state passed to memos.nvim.";
    };

    listOrderBy = lib.mkOption {
      type = lib.types.str;
      default = "pinned desc, update_time desc";
      description = "Server-side memo list ordering.";
    };

    autoSave = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether memos.nvim should save memo buffers automatically.";
    };

    templateTag = lib.mkOption {
      type = lib.types.strMatching "[^#].*";
      default = "type/template";
      description = "Template tag passed to memos.nvim without a leading #; Unicode tags are supported.";
    };

    keymaps.open = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "<leader>mm";
      description = "Normal-mode keymap for opening the Memos list. Set to null to disable.";
    };

    window = lib.mkOption {
      type = lib.types.attrs;
      default = {
        enable_float = true;
        width = 0.85;
        height = 0.85;
        border = "rounded";
      };
      description = "Window configuration passed to memos.nvim.";
    };
  };

  config = lib.mkIf cfg.enable {
    extraPlugins = [
      pkgs.vimPlugins.plenary-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "memos.nvim";
        src = inputs.memos-nvim;
        dependencies = [ pkgs.vimPlugins.plenary-nvim ];
      })
    ];

    extraPackages = [ pkgs.curl ];

    extraConfigLua = ''
      local function nvimx_config_home_path(relative)
        local config_home = vim.env.XDG_CONFIG_HOME
        if not config_home or config_home == "" then
          config_home = vim.fn.expand("~/.config")
        end
        return config_home .. "/" .. relative
      end

      local memos_config = ${lib.generators.toLua { } setupConfig}
      memos_config.env_file = ${
        if cfg.envFile == null then
          "nil"
        else if cfg.envFile == defaultEnvFile then
          ''nvimx_config_home_path("sops-nix/secrets/rendered/memos.env")''
        else
          "vim.fn.expand(${lib.generators.toLua { } cfg.envFile})"
      }
      require("memos").setup(memos_config)
    '';

    keymaps = lib.optional (cfg.keymaps.open != null && cfg.keymaps.open != "") {
      mode = "n";
      key = cfg.keymaps.open;
      action = "<cmd>Memos<CR>";
      options.desc = "Open Memos list";
    };
  };
}
