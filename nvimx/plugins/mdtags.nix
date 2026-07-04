{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.nvimx.mdtags;
  defaultEnvFile = "<nvimx-config-home>/sops-nix/secrets/rendered/chatanywhere.env";
  defaultSystemPromptFile = "<nvimx-stdpath-config>/memos/tags_rule.md";
in
{
  options.nvimx.mdtags = {
    enable = lib.mkEnableOption "mdtags.nvim" // {
      default = true;
    };

    envFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = defaultEnvFile;
      description = "Runtime env file containing OpenAI-compatible API settings for mdtags.nvim.";
    };

    systemPromptFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = defaultSystemPromptFile;
      description = "Runtime Markdown tag-generation rules file passed to mdtags.nvim.";
    };
  };

  config = lib.mkIf cfg.enable {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "mdtags.nvim";
        src = inputs.mdtags-nvim;
      })
    ];

    extraPackages = [ pkgs.curl ];

    extraConfigLua = ''
      local function nvimx_mdtags_config_home_path(relative)
        local config_home = vim.env.XDG_CONFIG_HOME
        if not config_home or config_home == "" then
          config_home = vim.fn.expand("~/.config")
        end
        return config_home .. "/" .. relative
      end

      local mdtags_config = {
        env_file = ${
          if cfg.envFile == null then
            "nil"
          else if cfg.envFile == defaultEnvFile then
            ''nvimx_mdtags_config_home_path("sops-nix/secrets/rendered/chatanywhere.env")''
          else
            "vim.fn.expand(${lib.generators.toLua { } cfg.envFile})"
        },
        system_prompt_file = ${
          if cfg.systemPromptFile == null then
            "nil"
          else if cfg.systemPromptFile == defaultSystemPromptFile then
            ''vim.fn.stdpath("config") .. "/memos/tags_rule.md"''
          else
            "vim.fn.expand(${lib.generators.toLua { } cfg.systemPromptFile})"
        },
      }

      require("mdtags").setup(mdtags_config)
    '';
  };
}
