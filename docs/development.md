# Development Guidelines

This document outlines coding standards, step-by-step instructions for extending the configuration, and guidelines for adding keymaps and plugins.

## Coding Standards

### Nix Files
- **Formatting**: Always format Nix files using `nixfmt` before committing.
- **Indentation**: Use **2 spaces** for indentation.
- **Library helpers**: Favor built-in Nixpkgs library functions (`lib.mkIf`, `lib.mkOption`, `lib.mkEnableOption`) for option and configuration definitions.

### Lua Code in Nix
- When writing raw Lua scripts inside Nix files (using `__raw` or multiline strings `''`), adhere to Neovim Lua style guidelines.
- Prefer local functions over global variables to prevent scope pollution.

---

## Development Rule: Incremental Commits
- **Rule**: Stage and commit related changes *immediately* upon completing a specific subtask or plan checklist item. Do not accumulate large, multi-feature diffs.
- **Rationale**: Keeps git history atomic, makes peer reviews easier, and enables safe rollbacks.

---

## How to Add a New Plugin

1. Create a new Nix file under `nvimx/plugins/<plugin-name>.nix`.
2. Declare the configuration for the plugin:
   ```nix
   { ... }:
   {
     plugins.<plugin-name> = {
       enable = true;
       settings = {
         # configuration parameters
       };
     };
   }
   ```
3. Import the file in `nvimx/plugins/default.nix`:
   ```nix
     imports = [
       ...
       ./<plugin-name>.nix
     ];
   ```

---

## How to Add a New Language Preset

1. Create a new Nix file under `nvimx/presets/<language>.nix`.
2. Define the toggle option and setup LSP and treesitter configuration:
   ```nix
   { lib, config, pkgs, ... }:
   {
     options.nvimx.preset.<language>.enable = lib.mkEnableOption "<language>";
     config = lib.mkIf (config.nvimx.preset.<language>.enable) {
       plugins.lsp.servers.<server-name>.enable = true;
       plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
         <language>
       ];
     };
   }
   ```
3. Import your preset file in `nvimx/presets/default.nix`.
4. Expose the preset in [presets.nix](file:///home/masa/Projects/nixvim/nvimx/presets.nix) by calling the `mkPreset` helper in the attribute set:
   ```nix
     <language> = mkPreset [ "<language>" ];
   ```
   If this preset should also be included in the pre-composed `all` preset, append its name string to the arguments of `all`'s `mkPreset` call.


---

## Keymaps Conventions

1. **Avoid Conflicts**: Keep standard Vim keymaps unimpeded unless necessary. If replacing a native key (e.g. `s` or `f`), ensure it is remapped to `<leader>` to preserve native functionality.
2. **LSP Mappings**: Define LSP-related hotkeys under `plugins.lsp.keymaps` instead of mapping them globally. This ensures they are buffer-local and only active when an LSP server attaches to the buffer.
