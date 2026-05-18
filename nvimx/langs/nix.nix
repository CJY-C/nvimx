{
  lib,
  system,
  config,
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
          description = "Name of homeConfigurations key in the flake, used for looking up Home Manager options. Only set this if using HM standalone.";
          default = "";
        };
        flakeInputs = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = ''Mapping of input name in flake to path to lookup its options.
            If the module is at \"inputs.stylix.homeModules.stylix\", then write \"stylix\" = \"homeModules.stylix\";
          '';
          default = { };
        };
      };
    };
  };

config = lib.mkIf (config.nvimx.preset.nix.enable) {
    nvimx.lsp.enable = true;

    lsp.servers.nixd = {
      enable = true;
      activate = true;
      config = {
        settings.nixd = let
          q = "\\\""; # nix's quote ("), escaped in lua (\"), escaped in nix
          flakeExpr = "(builtins.getFlake ${q}\' .. find_flake_dir() .. \'${q})"; # see lsp.luaConfig below
          # user supplied values may contain special characters, need escaping to use as attr path (in nix)
          escape = path: lib.pipe path [
            (lib.splitString ".")
            (map (s: q + s + q))
            (builtins.concatStringsSep ".")
          ];
        in with config.nvimx.preset.nix.nixd; {
          diagnostic.suppress = [ "sema-extra-with" ];

        # Tell nixd where to lookup module options and pkgs
        # by providing nix exprs (in lua) that gets the options/pkgs from the flake
        # for nixpkgs, this is the pkgs path
        # for nixos/hm, this is flake.nixosConfigurations/homeConfigurations.<name>.options
        # for arbitrary flake inputs, this is the path to module options
        # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
        
          nixpkgs.expr = if nixpkgsName != "" 
            then {
              # need to use __raw because we want flake_dir in flakeExpr to be interpolated 
              __raw =  "\'${flakeExpr}.inputs.${escape nixpkgsName}.legacyPackages.${system}\'";
            }
            else "import <nixpkgs> { }";

          # flake inputs and default values
          options = lib.mapAttrs
            (_: path: {
              expr.__raw = "\'${path}\'";
            })
            ( # input = full path (flake.full_path) to module options
              lib.optionalAttrs (nixosConfKey != "") {
                "nixos" = "${flakeExpr}.nixosConfigurations.${escape nixosConfKey}.options";
              } // lib.optionalAttrs (hmConfKey != "") {
                "home-manager]" = "${flakeExpr}.homeConfigurations.${escape hmConfKey}.options";
              } // lib.mapAttrs (input: path: 
                "${flakeExpr}.inputs.${escape input}.${escape path}.options"
              ) flakeInputs
            );
        };
      };
    };

    lsp.luaConfig.pre = ''
      -- search up the path for flake directory, falllback to cwd
      function find_flake_dir()
        local dir = vim.fn.getcwd()
        while dir ~= "/" do
          if vim.fn.filereadable(dir .. "/flake.nix") == 1 then
            return dir
          end
          dir = vim.fn.fnamemodify(dir, ":h")
        end
        return vim.fn.getcwd()
      end
    '';

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      nix
    ];
  };
}

# debug:
# :lua print(vim.inspect(vim.lsp.get_clients()))
