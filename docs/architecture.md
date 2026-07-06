# Project Architecture

This document describes the high-level architecture, module design, and presets mechanism used in this Nixvim configuration.

## Directory Structure

```
.
├── .agents/            # Workspace rules for AI assistants
├── docs/               # Development documentation
├── nvimx/              # Main Nixvim configuration modules
│   ├── keys/           # Keymap definitions (separated by functionality)
│   │   ├── default.nix # Entrypoint importing other key files
│   │   ├── editing.nix # Editing (Yank, paste, indent) keymaps
│   │   ├── lsp.nix     # LSP navigation (go-to-definition, hover) keymaps
│   │   ├── terminal.nix# Neovim terminal mode keymaps
│   │   └── wintab.nix  # Window and tab navigation keymaps
│   ├── plugins/        # Plugin-specific configurations
│   │   ├── default.nix # General plugin declarations & configuration
│   │   ├── autopairs.nix# Automatic bracket and quote pairing
│   │   ├── blink-cmp.nix# Autocomplete engine
│   │   ├── flash.nix   # Flash navigation plugin
│   │   ├── lualine.nix # Statusline plugin
│   │   └── ...         # Other plugins (telescope, yazi, etc.)
│   ├── presets/        # Language-specific presets
│   │   ├── default.nix # Presets list entrypoint
│   │   ├── nix.nix     # Nix LSP (nixd), formatter, and treesitter config
│   │   ├── rust.nix    # Rust LSP (rust-analyzer) & treesitter config
│   │   └── ...         # Other languages (Python, Typst, LaTeX, etc.)
│   ├── default.nix     # Core configurations (globals, options, colorscheme)
│   ├── lsp.nix         # LSP core engine config (plugins.lsp)
│   └── treesitter.nix  # Treesitter core configuration
├── flake.nix           # Entrypoint of the Nix flake
├── flake.lock          # Locked flake dependencies
└── presets.nix         # Definition of Nixvim package presets (the targets)
```

---

## Modularity via Presets

The core value of this configuration is its **preset-based modular design**. Instead of loading every language plugin and LSP globally, the configurations are split into optional modules inside `nvimx/presets/`.

### 1. Preset Declaration (`nvimx/presets/*.nix`)
Each language preset defines a boolean option (e.g., `nvimx.preset.rust.enable`) and conditionally enables its LSP server, tree-sitter grammars, and related tools:
```nix
options.nvimx.preset.rust.enable = lib.mkEnableOption "rust";
config = lib.mkIf (config.nvimx.preset.rust.enable) {
  plugins.lsp.servers.rust_analyzer.enable = true;
  plugins.treesitter.grammarPackages = [ rust ];
};
```

### 2. Presets Assembly (`presets.nix`)

In [presets.nix](../presets.nix), presets are defined using a functional pattern. It takes `lib` from Nixpkgs and uses a helper function `mkPreset` to generate target package configurations:

```nix
lib:
let
  base = {
    imports = [ ./nvimx ];
  };
  # Helper to generate a preset package configuration enabling a list of presets
  mkPreset = presets: base // {
    nvimx.preset = lib.genAttrs presets (name: { enable = true; });
  };
in
{
  default = base;
  rust = mkPreset [ "rust" ];
  # ...
  # Pre-composed preset package containing all language configurations
  all = mkPreset [ "configs" "latex" "lua" "markdown" "nix" "python" "rust" "shells" "typst" ];
}
```

These presets are compiled into separate packages (e.g. `packages.x86_64-linux.rust` or `packages.x86_64-linux.all`) via the Flake outputs.

---

## Flake Integration & Custom Builds

`nvimx` exposes a public helper function `lib.makeNvimx` in `flake.nix` so that other flakes (e.g., your system/home-manager configuration flake) can import `nvimx` and build customized Neovim packages dynamically.

### Helper Function Signature
`lib.makeNvimx` supports two invocation styles:

1. **Attribute Set Signature (Recommended)**: Accepts an attribute set to optionally inject a custom `pkgs` (e.g., with system overlays) or custom Nixvim `module` list:
   ```nix
   makeNvimx = { system, pkgs ? pkgsOf system, module ? [] }: ...
   ```
2. **Positional Signature (Backward Compatible)**: Takes the target `system` and a custom Nixvim module, compiling it immediately:
   ```nix
   makeNvimx = system: nixvimModule: ...
   ```

### Usage Example in a System Flake
You can integrate `nvimx` into your system flake's outputs like this:
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvimx.url = "github:yourusername/nvimx"; # path or github uri
  };

  outputs = { self, nixpkgs, nvimx, ... }: {
    # Build a custom package for a specific system using the recommended attribute set signature
    packages.x86_64-linux.my-neovim = nvimx.lib.makeNvimx {
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.x86_64-linux; # optional: inject custom pkgs
      module = {
        # Enable specific presets
        nvimx.preset.rust.enable = true;
        nvimx.preset.nix.enable = true;

        # Inject other custom Nixvim configuration here
        opts.relativenumber = false;
      };
    };
  };
}
```

---

## LSP and Autocomplete Architecture

LSP integration is built on two highly mature, stable plugins:
1. **`plugins.lsp` (nvim-lspconfig)**: Provides the standard interface to configure language servers.
2. **`plugins.blink-cmp`**: A modern, high-performance completion engine written in Rust. It hooks into the LSP client to provide fast, fuzzy-completion popups, using its default keymap preset.

General insert-mode editing helpers belong in the base plugin layer. `plugins.nvim-autopairs` is enabled there through NixVim's native module so bracket/quote pairing is available across all presets; it owns `<CR>` and `<BS>` pair behavior.

Instead of hardcoding formatting logic in Neovim's LSP autocommands, formatting is handled by the mature `plugins.conform-nvim` module. Language presets map their formatting backends (e.g., `nixfmt` for Nix) straight into `conform-nvim`'s config, falling back to standard LSP formatting if none are defined. Additionally, automatic format-on-save can be disabled globally or overridden on a per-preset basis using the `nvimx.lsp.formatOnSave` option.

### Nix Preset and Nixd Configuration

The Nix language preset (`nvimx.preset.nix`) configures `nixd` for intelligent Nix autocomplete, options lookup, and diagnostics. It provides the following options under `nvimx.preset.nix.nixd`:

- **Flake Paths**:
  - `nixpkgsName`: Name of nixpkgs input in the flake.
  - `nixosConfKey`: Name of the `nixosConfigurations` key in the flake.
  - `hmConfKey`: Name of the `homeConfigurations` (standalone) or `nixosConfigurations` (integrated) key in the flake.
  - `nixvimPackage`: Name of the `packages.${system}.nixvim` key in the flake.
  - `flakeInputs`: Map of other flake input names to option lookup paths.
- **Home Manager Integration**:
  - `homeManagerMode`: Either `"standalone"` (default) to lookup `homeConfigurations`, or `"nixos-module"` to lookup integrated Home Manager configurations within a NixOS system.
- **Custom Expressions**:
  - `optionExprs`: An attribute set of custom Nix option lookup expressions. Placeholders like `\${flakeExpr}` or `__FLAKE_EXPR__` are resolved to the dynamic flake directory.
- **CLI Options**:
  - `cmd`: Binary array to execute (defaults to `[ "nixd" ]`).
  - `extraArgs`: Extra CLI arguments for `nixd`.
  - `useCliOptionsExpr`: If `true`, passes `--nixpkgs-expr` and `--nixos-options-expr` as CLI arguments to `nixd` rather than through LSP configuration, which helps with certain completion tools.

#### Flake Directory Resolution
The LSP uses a dynamic `find_flake_dir()` Lua helper function which resolves the flake root from the current buffer's file path by looking for `flake.nix` upwards, then falls back to Neovim's current working directory (`cwd`). It intentionally does not use `.git` as a flake root marker, because the result is passed to `builtins.getFlake` and must point at a real flake.
