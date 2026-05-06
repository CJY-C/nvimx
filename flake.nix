{
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

  outputs = { nixpkgs, nixvim, ... }@inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    nixvimModules = import ./modules.nix;
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsOf = system: import nixpkgs { inherit system; config.allowUnfree = true; };
    moduleArgs = system: (
      let 
        pkgs = pkgsOf system;
      in {
        inherit pkgs nixvim system inputs;
        inherit (pkgs) stdenv;
      }
    );
  in rec {
    inherit nixvimModules;
    makeNixvimWithModule = system: m:
      let 
        pkgs = pkgsOf system;
      in nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = m // { imports = (m.imports or []) ++ [ ./nixvim ]; };
        extraSpecialArgs = moduleArgs system;
        inherit pkgs;
      };

    packages = forEachSystem (system: let 
        pkgs = pkgsOf system;
      in pkgs.lib.mapAttrs (_: makeNixvimWithModule system) nixvimModules);

    devShells = forEachSystem (system: let
      pkgs = pkgsOf system;
    in {
      default = pkgs.mkShell (let
        nixvimModule = {
          nvimx.nix.enable = true;
          nvimx.nix.nixd = { # enable lsp to lookup of nixvim options
            nixpkgsName = "nixpkgs";
            flakeInputs.nixvim = "nixvimConfigurations.${system}.default";
          };
        };
        nixvimPkg = makeNixvimWithModule system nixvimModule;
      in {
        packages = [ nixvimPkg ];
      });
    });
  };
}
