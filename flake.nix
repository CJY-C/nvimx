{
  description = "Project-based, modular Neovim configuration via NixVim.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim"; # Dont follow nixpkgs; see: https://nix-community.github.io/nixvim/user-guide/faq.html#how-do-i-solve-name-cannot-be-found-in-pkgs
    tabby = {
      url = "github:nanozuki/tabby.nvim";
      flake = false;
    };
    winresize = {
      url = "github:pogyomo/winresize.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }@inputs: let
    nixvimModules = import ./presets.nix;
    forAllSystems = with nixpkgs.lib; genAttrs platforms.all;
    pkgsOf = system: import nixpkgs { inherit system; config.allowUnfree = true; };
    moduleArgs = system: (
      let 
        pkgs = pkgsOf system;
      in {
        inherit nixvim system inputs;
        inherit (pkgs) stdenv;
      }
    );
  in {
    inherit nixvimModules;
    makeNvimxWithModule = system: m:
      nixvim.legacyPackages.${system}.makeNixvimWithModule {
        pkgs = pkgsOf system;
        module = [
          m
          (import ./nvimx)
          { _module.args = moduleArgs system; }
        ];
      };
    
    apps = forAllSystems (system: nixpkgs.lib.mapAttrs (_: pkg: {
        type = "app";
        program = "${pkg}/bin/nvim";
      }) self.packages.${system});

    packages = forAllSystems (system: 
      nixpkgs.lib.mapAttrs (_: self.makeNvimxWithModule system) nixvimModules);

    devShells = forAllSystems (system: let
      pkgs = pkgsOf system;
    in {
      default = pkgs.mkShell (let
        nixvimModule = {
          nvimx.preset.nix.enable = true;
          nvimx.preset.nix.nixd = { # enable lsp to lookup of nixvim options
            nixpkgsName = "nixpkgs";
            flakeInputs.nixvim = "nixvimConfigurations.${system}.default";
          };
        };
        nixvimPkg = self.makeNvimxWithModule system nixvimModule;
      in {
        packages = [ nixvimPkg ];
      });
    });
  };
}
