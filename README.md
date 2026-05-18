# `n`v`i`m`x`

Project-based, modular Neovim configuration via NixVim.

Nvimx provides many presets based on different language (lsp, treesitter) support and different uses, allowing you to choose what is installed on a neovim instance per project. Works well with [direnv](https://direnv.net/).

Nvimx exports these module/package presets:
- `default`/`base` - Base Neovim instance, contains all plugins, no language support. All other presets automatically includes this base.
- Languages (ts = treesitter):
  - `configs` - ts for `ini`, `json`, `kdl`, `yaml`, `toml`
  - `latex` - ts & lsp ([texlab](https://github.com/latex-lsp/texlab))
  - `nix` - ts & lsp ([nixd](https://github.com/nix-community/nixd/))
  - `shells` - ts and lsp for `bash`, `fish`, `zsh`
  - `typst` - ts and lsp ([tinymist](https://github.com/Myriad-Dreamin/tinymist))

Additionally, you can set `nvimx.treesitter.enableAllGrammars = true` to get ts for all languages without individually enabling variants.

## Usage
1. Use a packaged presets (i.e. via `nix run`):
```bash
nix run github:allen-liaoo/nvimx#{preset}
```
For the default preset, you can omit `#default`. 

You may need to enable experimental features by passing in this environment variable:
```
NIX_CONFIG="extra-experimental-featues = nix-command flakes pipe-operators"
```

2. Construct a module in a flake (i.e. in `devShells`).
Nvimx flake outputs `makeNixvimWithModule (system: nixvimModule: ...)` to be used in this case. Presents have options under `nvimx.${preset}`, and need to be opted in with `nvimx.${preset}.enable = true`.
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvimx = {
      url = "github:allen-liaoo/nvimx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim }: let
  in {
    devShells = let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in ${system}.default = pkgs.mkShell (let
      nixvimModule = {
        # enable the presets you want to use
        nvimx.typst.enable = true;

        # or add custom nixvim or nvimx options here
        plugins.xyz.enable = true;
      };
      nixvimPkg = nvimx.makeNixvimWithModule system nixvimModule; # package it!
    in {
      packages = [ nixvimPkg ];
    });
  };
}
```

## Credits
Inspired by [ar-at-localhost/np](https://github.com/ar-at-localhost/np).
