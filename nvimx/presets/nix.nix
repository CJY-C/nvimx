{
  lib,
  system,
  config,
  pkgs,
  ...
}:

{
  options = {
    nvimx.preset.nix = {
      enable = lib.mkEnableOption "nix";

      nixd = {
        # Info needed for Nixd lookup of nixpkgs/nixos options/hm options/custom flake input options
        nixpkgsName = lib.mkOption {
          type = lib.types.str;
          description = "Name of nixpkgs input in the flake, used for looking up packages.";
          default = "";
        };
        nixosConfKey = lib.mkOption {
          type = lib.types.str;
          description = "Name of nixosConfigurations key in the flake, used for looking up NixOS options.";
          default = "";
        };
        hmConfKey = lib.mkOption {
          type = lib.types.str;
          description = "Name of homeConfigurations/nixosConfigurations key in the flake, used for looking up Home Manager options.";
          default = "";
        };
        nixvimPackage = lib.mkOption {
          type = lib.types.str;
          description = "Name of nixvim package key in the flake, used for looking up Nixvim options.";
          default = "";
        };
        flakeInputs = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = ''
            Mapping of input name in flake to path to lookup its options.
            If the module is at \"inputs.stylix.homeModules.stylix\", then write \"stylix\" = \"homeModules.stylix\";
          '';
          default = { };
        };
        homeManagerMode = lib.mkOption {
          type = lib.types.enum [ "standalone" "nixos-module" ];
          description = "Home Manager mode: 'standalone' (homeConfigurations) or 'nixos-module' (integrated as a module under nixosConfigurations).";
          default = "standalone";
        };
        homeManagerUser = lib.mkOption {
          type = lib.types.str;
          description = "Username for home-manager when homeManagerMode is 'nixos-module' (not used by default as type.getSubOptions gets all options).";
          default = "";
        };
        optionExprs = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Arbitrary options lookup raw expressions. Key is option name (e.g., 'stylix'), value is expression (e.g. '\${flakeExpr}.inputs.stylix.homeModules.stylix.options'). Occurrences of '\${flakeExpr}' and '__FLAKE_EXPR__' are replaced by the dynamic flake lookup expression.";
          default = { };
        };
        cmd = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Command line to run nixd.";
          default = [ "nixd" ];
        };
        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Extra arguments to pass to the nixd CLI.";
          default = [ ];
        };
        useCliOptionsExpr = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to pass nixpkgs-expr and nixos-options-expr as command line arguments to nixd rather than purely through LSP configuration.";
          default = false;
        };
      };
    };
  };

  config = lib.mkIf (config.nvimx.preset.nix.enable) {
    nvimx.lsp.enable = true;

    plugins.lsp.servers.nixd = {
      enable = true;
      extraOptions.cmd =
        let
          cfg = config.nvimx.preset.nix.nixd;
          q = "\\\""; # nix's quote ("), escaped in lua (\"), escaped in nix
          flakeExpr = "(builtins.getFlake ${q}\' .. find_flake_dir() .. \'${q})"; # see lsp.luaConfig below
          # user supplied values may contain special characters, need escaping to use as attr path (in nix)
          escape =
            path:
            lib.pipe path [
              (lib.splitString ".")
              (map (s: q + s + q))
              (builtins.concatStringsSep ".")
            ];
          nixpkgs_expr =
            if cfg.nixpkgsName != "" then
              "\'${flakeExpr}.inputs.${escape cfg.nixpkgsName}.legacyPackages.${system}\'"
            else
              "\'import <nixpkgs> { }\'";
          nixos_expr =
            if cfg.nixosConfKey != "" then
              "\'${flakeExpr}.nixosConfigurations.${escape cfg.nixosConfKey}.options\'"
            else
              "\'\'";
          toLuaList = list: "{" + (lib.concatMapStringsSep ", " (s: "\"${s}\"") list) + "}";
        in
        {
          __raw = ''
            (function()
              local cmd = ${toLuaList cfg.cmd}
              if ${if cfg.useCliOptionsExpr then "true" else "false"} then
                table.insert(cmd, "--nixpkgs-expr=" .. ${nixpkgs_expr})
                local nixos_expr = ${nixos_expr}
                if nixos_expr ~= "" then
                  table.insert(cmd, "--nixos-options-expr=" .. nixos_expr)
                end
              end
              local extra = ${toLuaList cfg.extraArgs}
              for _, v in ipairs(extra) do
                table.insert(cmd, v)
              end
              return cmd
            end)()
          '';
        };

      settings =
        let
          q = "\\\""; # nix's quote ("), escaped in lua (\"), escaped in nix
          flakeExpr = "(builtins.getFlake ${q}\' .. find_flake_dir() .. \'${q})"; # see lsp.luaConfig below
          # user supplied values may contain special characters, need escaping to use as attr path (in nix)
          escape =
            path:
            lib.pipe path [
              (lib.splitString ".")
              (map (s: q + s + q))
              (builtins.concatStringsSep ".")
            ];
        in
        with config.nvimx.preset.nix.nixd;
        {
          diagnostic.suppress = [ "sema-extra-with" ];

          # Tell nixd where to lookup module options and pkgs
          # by providing nix exprs (in lua) that gets the options/pkgs from the flake
          # for nixpkgs, this is the pkgs path
          # for nixos/hm, this is flake.nixosConfigurations/homeConfigurations.<name>.options
          # for arbitrary flake inputs, this is the path to module options
          # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md

          nixpkgs.expr =
            if nixpkgsName != "" then
              {
                # need to use __raw because we want flake_dir in flakeExpr to be interpolated
                __raw = "\'${flakeExpr}.inputs.${escape nixpkgsName}.legacyPackages.${system}\'";
              }
            else
              "import <nixpkgs> { }";

          # flake inputs and default values
          options =
            let
              defaultExprs =
                lib.optionalAttrs (nixosConfKey != "") {
                  "nixos" = "${flakeExpr}.nixosConfigurations.${escape nixosConfKey}.options";
                }
                // lib.optionalAttrs (hmConfKey != "") (
                  if homeManagerMode == "standalone" then {
                    "home-manager" = "${flakeExpr}.homeConfigurations.${escape hmConfKey}.options";
                  } else {
                    "home-manager" = "${flakeExpr}.nixosConfigurations.${escape hmConfKey}.options.home-manager.users.type.getSubOptions [ ]";
                  }
                )
                // lib.optionalAttrs (nixvimPackage != "") {
                  "nixvim" = "${flakeExpr}.packages.${system}.${escape nixvimPackage}.options";
                }
                // lib.mapAttrs (
                  input: path: "${flakeExpr}.inputs.${escape input}.${escape path}.options"
                ) flakeInputs;

              resolvedOptionExprs = lib.mapAttrs (
                _: expr: lib.replaceStrings [ "\${flakeExpr}" "__FLAKE_EXPR__" ] [ flakeExpr flakeExpr ] expr
              ) optionExprs;

              mergedExprs = defaultExprs // resolvedOptionExprs;
            in
            lib.mapAttrs
              (_: path: {
                expr.__raw = "\'${path}\'";
              })
              mergedExprs;
        };
    };

    extraPackages = with pkgs; [
      nixfmt
    ];

    lsp.luaConfig.pre = ''
      -- search up the path for flake directory, fallback to cwd
      function find_flake_dir()
        local path = vim.api.nvim_buf_get_name(0)
        if path and path ~= "" then
          local dir = vim.fs.dirname(path)
          local root = vim.fs.root(dir, { "flake.nix", ".git" })
          if root then
            return root
          end
        end
        return vim.fn.getcwd()
      end
    '';

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      nix
    ];

    plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
  };
}

# debug:
# :lua print(vim.inspect(vim.lsp.get_clients()))
