# `n`v`i`m`x`

Project-based, modular Neovim configuration via NixVim.

Nvimx provides many presets based on different language (lsp, treesitter) support and different uses, allowing you to choose what is installed on a neovim instance per project. Works well with [direnv](https://direnv.net/).

Nvimx exports these module/package presets:
- `default`/`base` - Base Neovim instance, contains all plugins, no language support. All other presets automatically includes this base.
- Languages (ts = treesitter):
  - `configs` - ts for `ini`, `json`, `kdl`, `yaml`, `toml`
  - `latex` - ts & lsp ([texlab](https://github.com/latex-lsp/texlab))
  - `lua` - ts & lsp ([lua-language-server](https://github.com/LuaLS/lua-language-server))
  - `markdown` - ts & lsp ([marksman](https://github.com/artempyanykh/marksman))
  - `nix` - ts & lsp ([nixd](https://github.com/nix-community/nixd/))
  - `python` - ts & lsp ([pyright](https://github.com/microsoft/pyright))
  - `rust` - ts & lsp ([rust-analyzer](https://github.com/rust-lang/rust-analyzer))
  - `shells` - ts and lsp for `bash`, `fish`, `zsh`
  - `typst` - ts and lsp ([tinymist](https://github.com/Myriad-Dreamin/tinymist))

Additionally, you can set `nvimx.treesitter.enableAllGrammars = true` to get ts for all languages without individually enabling variants.

## Memos

The base configuration includes [`memos.nvim`](https://github.com/CJY-C/memos.nvim) for working with a self-hosted Memos instance from Neovim.

By default, nvimx configures it with:

```nix
nvimx.memos.envFile = "~/.config/sops-nix/secrets/rendered/memos.env";
```

The runtime env file should contain:

```sh
MEMOS_HOST=http://127.0.0.1:5230
MEMOS_TOKEN=your-token
```

The token is intentionally not exposed as a Nix option, so it does not enter the Nix store or git history. Use `nvimx.memos.envFile` to point to another secret file, or set `MEMOS_HOST` and `MEMOS_TOKEN` in the Neovim process environment.

Commands:

- `:Memos` - Toggle the memo list.
- `:MemosCreate` - Open a new memo buffer.
- `:MemosSave` - Save the current memo buffer.

The default global keymap is `<leader>mm` for `:Memos`. Set `nvimx.memos.keymaps.open = null;` to disable it.

## Usage
1. Run directly:
```bash
nix run github:allen-liaoo/nvimx
```
You can run a preset by appending `#{preset}`.

You may need to enable experimental features by passing in this environment variable:
```
NIX_CONFIG="extra-experimental-featues = nix-command flakes"
```

2. Construct a module in a flake (i.e. in `devShells`).
Nvimx flake outputs `makeNvimxWithModule (system: nvimxModule: ...)` to be used in this case. Presets have options under `nvimx.preset.${preset}`, and need to be opted in with `nvimx.preset.${preset}.enable = true`.
```nix
{
  outputs = { self, nixpkgs, nixvim }: let
  in {
    devShells = let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in ${system}.default = pkgs.mkShell (let
      nixvimModule = {
        # enable the presets you want to use
        nvimx.preset.typst.enable = true;

        # or add custom nixvim or nvimx options here
        plugins.xyz.enable = true;
      };
      nixvimPkg = nvimx.makeNvimxWithModule system nixvimModule; # package it!
    in {
      packages = [ nixvimPkg ];
    });
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvimx = {
      url = "github:allen-liaoo/nvimx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

## Credits
Inspired by [ar-at-localhost/np](https://github.com/ar-at-localhost/np).
