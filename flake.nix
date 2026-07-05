{
  description = "Project-based, modular Neovim configuration via NixVim.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim"; # Dont follow nixpkgs; see: https://nix-community.github.io/nixvim/user-guide/faq.html#how-do-i-solve-name-cannot-be-found-in-pkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    memos-nvim = {
      url = "github:CJY-C/memos.nvim/refactor-latest-api-core";
      flake = false;
    };
    mdtags-nvim = {
      url = "github:CJY-C/mdtags.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      ...
    }@inputs:
    let
      nixvimModules = import ./presets.nix nixpkgs.lib;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsOf =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      moduleArgs =
        system:
        (
          let
            pkgs = pkgsOf system;
          in
          {
            inherit nixvim system inputs;
            inherit (pkgs) stdenv;
          }
        );
    in
    {
      inherit nixvimModules;
      lib = {
        # Expose a helper to build custom Neovim packages from other flakes
        makeNvimx =
          arg:
          if builtins.isString arg then
            (
              nixvimModule:
              self.lib.makeNvimx {
                system = arg;
                module = nixvimModule;
              }
            )
          else
            let
              args = arg;
              system = args.system;
              pkgs = args.pkgs or (pkgsOf system);
              module = args.module or [ ];
            in
            nixvim.legacyPackages.${system}.makeNixvimWithModule {
              inherit pkgs;
              module = (if builtins.isList module then module else [ module ]) ++ [
                (import ./nvimx)
                { _module.args = moduleArgs system; }
              ];
            };
      };

      makeNvimxWithModule =
        system: m:
        self.lib.makeNvimx {
          inherit system;
          module = m;
        };

      apps = forAllSystems (
        system:
        nixpkgs.lib.mapAttrs (name: pkg: {
          type = "app";
          program = "${pkg}/bin/nvim";
          meta.description = "Run the ${name} nvimx preset";
        }) self.packages.${system}
      );

      packages = forAllSystems (
        system: nixpkgs.lib.mapAttrs (_: self.makeNvimxWithModule system) nixvimModules
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = pkgsOf system;
        in
        pkgs.writeShellApplication {
          name = "nvimx-format";
          runtimeInputs = [ pkgs.nixfmt ];
          text = ''
            if [ "$#" -eq 0 ]; then
              find . -name '*.nix' -not -path './.git/*' -exec nixfmt {} +
            else
              nixfmt "$@"
            fi
          '';
        }
      );

      checks = forAllSystems (system: {
        default = self.packages.${system}.default;
        nix = self.packages.${system}.nix;
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsOf system;
        in
        {
          default = pkgs.mkShell (
            let
              nixvimModule = {
                imports = [ self.nixvimModules.all ];
                nvimx.preset.nix.nixd = {
                  # enable lsp to lookup of nixvim options
                  nixpkgsName = "nixpkgs";
                  nixvimPackage = "all";
                };
              };
              nixvimPkg = self.makeNvimxWithModule system nixvimModule;
            in
            {
              packages = [ nixvimPkg ];
            }
          );
        }
      );
    };
}
