# Project-Scoped Rules for AI Agents

These rules govern the behavior and coding standards for all agentic AI assistants (including Antigravity) working in this codebase.

## 1. Incremental Task Commits
- **Rule**: After completing a specific task/checklist item in the active plan, stage and commit the related changes *immediately* before proceeding to the next task.
- **Rationale**: Keeps git history incremental, clean, and easy to roll back if necessary.

## 2. API Stability and Mature Plugins
- **Rule**: Prefer mature, stable, and widely-tested Nixvim plugins (such as `plugins.lsp` wrapping `nvim-lspconfig`) over experimental native APIs (like Neovim's built-in `lsp` configuration module), unless the user explicitly requests otherwise.
- **Rationale**: Ensures cross-platform compatibility across Linux and macOS (Darwin) and different host CPU architectures (x86_64, aarch64/ARM), and keeps integration with other plugins (e.g., autocompletion with `blink-cmp`) robust.

## 3. Configuration Verification
- **Rule**: Before completing a task, always verify that the configuration compiles successfully:
  ```bash
  nix flake check --impure
  ```
- **Rationale**: Prevents committing code that fails to evaluate in the Nix module system.

## 4. Documentation Maintenance
- **Rule**: When introducing new presets, modifying project structure, or altering standard keymaps, update the corresponding markdown file in the `docs/` folder to maintain documentation integrity.
