# Commit Message Standards

We use the **Conventional Commits** specification to keep our git history clean, readable, and machine-parsable.

## Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

---

## Types

| Type | Description | Example |
| :--- | :--- | :--- |
| **`feat`** | A new feature / preset / plugin addition | `feat(preset/rust): enable rust-analyzer and treesitter` |
| **`fix`** | A bug fix / syntax error fix / deprecation warning fix | `fix(lsp): resolve Neovim 0.12 supports_method deprecation` |
| **`docs`** | Documentation changes only | `docs(rules): create .agents/AGENTS.md for AI guidelines` |
| **`style`** | Code formatting changes (spaces, semicolons) | `style: run nixfmt on presets directory` |
| **`refactor`** | A code change that neither fixes a bug nor adds a feature | `refactor(presets): migrate from native lsp to plugins.lsp` |
| **`perf`** | A code change that improves performance | `perf(blink-cmp): optimize completion delay settings` |
| **`build`** | Changes that affect the build system or dependencies | `build(flake): update nixpkgs flake input` |
| **`chore`** | Other changes that don't modify src or test files | `chore: remove unused temporary test files` |

---

## Guidelines

1. **Imperative Mood**: Use the imperative mood in the description (e.g., "add option", not "added option" or "adds option").
2. **First Word Lowercase**: Start the description with a lowercase letter.
3. **No Period at the End**: Do not put a period at the end of the description line.
4. **Scope**: Always specify a scope if the change is confined to a specific module, preset, or plugin (e.g. `(preset/nix)`, `(keys/lsp)`, `(lsp)`).
5. **Incremental Commits**: Remember to commit related changes *immediately* upon completing a specific task/checklist item.
