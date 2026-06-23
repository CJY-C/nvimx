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
In `presets.nix`, presets are combined into target packages:
```nix
let
  base = { imports = [ ./nvimx ]; };
in
{
  default = base; # Lightweight editor
  rust = base // {
    nvimx.preset.rust.enable = true; # Rust development editor
  };
}
```
These presets are compiled into separate packages (e.g. `packages.x86_64-linux.rust`) via the Flake outputs.

---

## LSP and Autocomplete Architecture

LSP integration is built on two highly mature, stable plugins:
1. **`plugins.lsp` (nvim-lspconfig)**: Provides the standard interface to configure language servers.
2. **`plugins.blink-cmp`**: A modern, high-performance completion engine written in Rust. It hooks into the LSP client to provide fast, fuzzy-completion popups.

A custom autocommand in `nvimx/lsp.nix` automatically hooks into Neovim's `LspAttach` event, registering automatic format-on-save for any LSP client that supports formatting (e.g. `nixd` using `nixfmt`).
