{
  description = "Project-based, modular Neovim configuration via NixVim.";
  inputs = {
    # aln-packages = {
    #   url = "github:allen-liaoo/nix-packages";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    makeNixvimWithModule = system: m:
      let 
        pkgs = pkgsOf system;
      in nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = [
          m
          (import ./nvimx)
          { _module.args = moduleArgs system; }
        ];
        inherit pkgs;
      };
    
    apps = forAllSystems (system: let 
        lib = (pkgsOf system).lib;
      in lib.mapAttrs (_: pkg: {
        type = "app";
        program = "${pkg}/bin/nvim";
      }) self.packages.${system});

    packages = forAllSystems (system: let 
        pkgs = pkgsOf system;
      in pkgs.lib.mapAttrs (_: self.makeNixvimWithModule system) nixvimModules);

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
        nixvimPkg = self.makeNixvimWithModule system nixvimModule;
      in {
        packages = [ nixvimPkg ];
      });
    });
  };
}
