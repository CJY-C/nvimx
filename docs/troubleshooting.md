# Troubleshooting Guide

This document covers common issues you might run into when working with this Nixvim configuration, along with solutions and debugging tips.

## 1. Local Configuration Changes Not Reflecting Globally

### Symptom
You edited files in `/nvimx` but running the global `nvim` command does not show any changes.

### Cause
Nix builds are immutable. Changing source files on disk does not automatically update Neovim binaries already installed in your system path (e.g. `/etc/profiles/per-user/...`).

### Solution
- **For temporary testing**: Run the configuration directly from the local directory:
  ```bash
  nix run .#nix -- <file-to-edit>
  # OR use devShell
  nix develop -c nvim <file-to-edit>
  ```
- **To apply changes globally**: Rebuild your Home Manager or NixOS configuration so that it builds a new Neovim package containing your latest edits.

---

## 2. Nix getFlake / "unlocked flake" errors

### Symptom
LSP (`nixd`) fails to initialize, or Nix commands throw:
`error: cannot call 'getFlake' on unlocked flake reference`

### Cause
In Git-based flakes, Nix will only evaluate files that are tracked by Git. If you added new configuration files but did not add them to Git, Nix cannot see them.

### Solution
Stage the untracked files so Git tracks them, allowing Nix to evaluate them:
```bash
git add <new-file>
```

---

## 3. Direnv & Nix Shell Integration

### Symptom
`which nvim` does not point to the Nix store path when entering the directory.

### Cause
`direnv` is either blocked or not hooked into your shell.

### Solution
1. Ensure `direnv` is allowed:
   ```bash
   direnv allow
   ```
2. Make sure you hook `direnv` in your `~/.bashrc` or `~/.zshrc`:
   ```bash
   # Add to ~/.zshrc
   eval "$(direnv hook zsh)"
   ```

---

## 4. Debugging LSP Issues

### Check Active LSP Clients
To see if `nixd` (or any other LSP server) is attached to the current buffer, run:
```vim
:lua =vim.lsp.get_clients()
```
If this returns an empty table `{}`:
- Check if your cursor is in a file with the correct filetype (e.g. `nix`).
- Check if the flake root is correctly detected. Nix option lookup needs a `flake.nix`; a plain `.git` directory is not enough for `builtins.getFlake`.

### Read LSP Log File
If an LSP client is crashing or failing, Neovim logs errors to the LSP log file.
You can view the log path:
```vim
:lua =vim.lsp.get_log_path()
```
And view its contents from your terminal:
```bash
tail -n 50 ~/.local/state/nvim/lsp.log
```
Check for initialization errors or Nix evaluation errors from `nixd`.
