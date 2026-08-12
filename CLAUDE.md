# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim config built on the [LazyVim](https://github.com/LazyVim/LazyVim) starter template. It lives at `~/.config/nvim`. There is no build or test suite — "running" it means starting `nvim` and watching for errors.

## Commands

```bash
nvim                      # load the config; startup errors surface immediately
nvim --headless "+Lazy! sync" +qa   # install/update plugins non-interactively
stylua .                  # format Lua (2 spaces, 120 cols; see stylua.toml — binary not installed by default)
```

Inside Neovim: `:Lazy` (plugin manager UI), `:Lazy sync`, `:Mason` (LSP/tool installer), `:checkhealth`, `:LspInfo`.

`lazy-lock.json` pins plugin commits and is tracked in git — `:Lazy sync`/`update` rewrites it, so expect it in diffs.

## Architecture

`init.lua` → `lua/config/lazy.lua` bootstraps lazy.nvim, imports the LazyVim base spec plus extras (typescript, json, mini-animate, alpha, and `lazyvim.plugins.extras.lang.yaml` via `lazyvim.json`), then imports `lua/plugins/`.

Every file in `lua/plugins/` returns a lazy.nvim spec table, auto-loaded by directory import. Specs are **merged by plugin URL** with LazyVim's defaults: repeating `"neovim/nvim-lspconfig"` with an `opts` table across several files (`lsp.lua`, `helm.lua`, `jdtls.lua`, `yaml-format.lua`) is intentional — each contributes a slice of the merged config. When changing LSP behavior, grep for the plugin name across `lua/plugins/` first; the setting you want may be defined in more than one place.

`lua/config/` holds non-plugin config loaded by LazyVim at fixed points: `options.lua` (before startup), `autocmds.lua` and `keymaps.lua` (on `VeryLazy`).

`ftplugin/java.lua` runs on every Java buffer and calls `jdtls.start_or_attach()` itself. `lua/plugins/jdtls.lua` deliberately keeps lspconfig from also starting jdtls — Java LSP is owned entirely by the ftplugin, not by LazyVim's LSP pipeline.

### Hardcoded absolute paths

`ftplugin/java.lua` and `lua/plugins/ale.lua` reference machine-specific paths (`/home/jake/.local/share/java/lombok.jar`, the Mason jdtls launcher jar and `config_linux`, `/home/jake/.config/checkstyle.xml`). These are load-bearing and Linux/user-specific.

### Formatting pipeline

Formatting is split across three mechanisms, which is the main source of surprise:

- **ALE** (`ale.lua`) fixes on save for Java (`google_java_format`) and JS/TS (`prettier`). `vim.g.ale_disable_lsp = 1` is set early in `lua/config/lazy.lua` — it must run before ALE loads.
- **jdtls** has `format.enabled = false`, so Java formatting is ALE's job alone.
- **yamlls** formats YAML, with `singleQuote = true` in `yaml-format.lua` to stop quote rewriting on save.

`vim.g.autoformat = true` in `options.lua` enables LazyVim's format-on-save for everything else.

### YAML / Helm

Helm buffers use `helm-ls` and explicitly stop `yamlls` when it attaches (`helm.lua`) — running both on the same buffer produces duplicate diagnostics. `yaml.lua` wires up `yaml-companion.nvim` for schema selection and shows the active schema in lualine; most of that file is commented-out alternative schemastore config kept for reference.

### Completion

Completion is blink.cmp, configured in `blink.lua`. An older parallel nvim-cmp setup was removed; if `nvim-cmp`/`lspkind` entries linger in `lazy-lock.json`, a `:Lazy sync` clears them.

`lua/plugins/example.lua` is the LazyVim template example and early-returns `{}` — do not edit it as if it were live config.
