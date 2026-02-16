# NeoVim Configuration Reference

**Configuration Date:** February 16, 2026  
**Leader Key:** `,` (comma)

---

## Table of Contents

1. [Loaded Plugins](#loaded-plugins)
2. [General Keybindings](#general-keybindings)
3. [LSP Keybindings](#lsp-keybindings)
4. [Navigation Keybindings](#navigation-keybindings)
5. [Plugin-Specific Keybindings](#plugin-specific-keybindings)
6. [Commands](#commands)

---

## Loaded Plugins

### Core Plugins

| Plugin | Description | Repository |
|--------|-------------|------------|
| **lazy.nvim** | Plugin manager | folke/lazy.nvim |
| **nvim-lspconfig** | LSP configuration helper | neovim/nvim-lspconfig |

### UI & Appearance

| Plugin | Description | Repository |
|--------|-------------|------------|
| **catppuccin** | Color scheme (Mocha variant) | catppuccin/nvim |
| **lualine.nvim** | Statusline | nvim-lualine/lualine.nvim |
| **bufferline.nvim** | Buffer tabs in tabline | akinsho/bufferline.nvim |
| **nvim-web-devicons** | Icons support | nvim-tree/nvim-web-devicons |

### File Management

| Plugin | Description | Repository |
|--------|-------------|------------|
| **nvim-tree.lua** | File explorer | nvim-tree/nvim-tree.lua |
| **telescope.nvim** | Fuzzy finder | nvim-telescope/telescope.nvim |
| **plenary.nvim** | Telescope dependency | nvim-lua/plenary.nvim |

### Version Control

| Plugin | Description | Repository |
|--------|-------------|------------|
| **vim-perforce** | Perforce integration | nfvs/vim-perforce |

### Language Support

| Plugin | Description | Repository |
|--------|-------------|------------|
| **Verible LSP** | SystemVerilog language server | chipsalliance/verible |

---

## General Keybindings

### Search & Navigation

| Key | Mode | Action | Notes |
|-----|------|--------|-------|
| `Space` | Normal | Start forward search `/` | Quick search |
| `,<CR>` | Normal | Clear search highlight | Clear `/` results |

### Editor Settings Applied

- **Relative line numbers** with absolute for current line
- **Case-insensitive search** that becomes case-sensitive with uppercase letters
- **Tab settings:** 3 spaces, expandtab enabled

---

## LSP Keybindings

### Code Navigation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `gd` | Normal | Go to definition | Jump to symbol definition |
| `gD` | Normal | Go to declaration | Jump to symbol declaration |
| `gr` | Normal | Find references | List all references to symbol |
| `gi` | Normal | Go to implementation | Jump to implementation |
| `K` | Normal | Hover documentation | Show symbol information |
| `Ctrl-o` | Normal | Jump back | Built-in Vim jump back |

### Code Editing

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,lr` | Normal | Rename symbol | Rename across all files |
| `,lf` | Normal | Format file | Format with Verible |
| `,la` | Normal | Code actions | Show available code actions |
| `,tf` | Normal | Toggle auto-format | Enable/disable format on save |

### Diagnostics

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,d` | Normal | Show diagnostic | Floating window with details |
| `Ctrl-k` | Normal | Previous diagnostic | Jump to previous error/warning |
| `Ctrl-j` | Normal | Next diagnostic | Jump to next error/warning |
| `,q` | Normal | Diagnostics to loclist | Open location list with all diagnostics |
| `,td` | Normal | Toggle diagnostics | Show/hide all diagnostic displays |

### Verible-Specific

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,vf` | Normal | Generate file list | Create/update `verible.filelist` |

---

## Navigation Keybindings

### Buffer Navigation

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `Tab` | Normal | Next buffer | Cycle to next buffer |
| `Shift-Tab` | Normal | Previous buffer | Cycle to previous buffer |
| `,bc` | Normal | Pick buffer to close | Interactive buffer close |

---

## Plugin-Specific Keybindings

### Telescope (Fuzzy Finder)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,ff` | Normal | Find files | Search files in project |
| `,fg` | Normal | Live grep | Search text in files |
| `,fb` | Normal | Buffers | List open buffers |
| `,fh` | Normal | Help tags | Search help documentation |

### NvimTree (File Explorer)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `,e` | Normal | Toggle file tree | Open/close file explorer |
| `,o` | Normal | Reveal current file | Show current file in tree |
| `+` | Normal (tree) | Change root to node | Set directory as new root |

**Additional NvimTree mappings** (when in tree window):
- Default mappings from `nvim-tree.api.config.mappings.default_on_attach()`
- Common: `a` (create), `d` (delete), `r` (rename), `x` (cut), `c` (copy), `p` (paste)

---

## Commands

### LSP Commands

| Command | Description |
|---------|-------------|
| `:LspInfo` | Show LSP client status and configuration |
| `:LspRestart` | Restart language server |
| `:LspStop` | Stop language server |
| `:VeribleGenerateFileList` | Manually generate verible.filelist |

### Buffer Commands

| Command | Description |
|---------|-------------|
| `:BufferLineCycleNext` | Next buffer (also `Tab`) |
| `:BufferLineCyclePrev` | Previous buffer (also `Shift-Tab`) |
| `:BufferLinePickClose` | Pick buffer to close (also `,bc`) |

### File Explorer Commands

| Command | Description |
|---------|-------------|
| `:NvimTreeToggle` | Toggle file tree (also `,e`) |
| `:NvimTreeFindFile` | Reveal current file in tree (also `,o`) |

---

## SystemVerilog File Types

The following file extensions are recognized as SystemVerilog/Verilog:

- `.v` → Verilog
- `.sv` → SystemVerilog
- `.svh` → SystemVerilog header
- `.vh` → Verilog header

---

## LSP Features (Verible)

### Automatic Features

1. **Syntax checking** - Real-time syntax error detection
2. **Linting** - Style and coding standard violations
3. **Auto-formatting on save** - OPTIONAL, disabled by default (toggle with `,tf`)
4. **File list generation** - Automatic creation of `verible.filelist` when opening SystemVerilog files

### LSP Configuration

- **Command:** `verible-verilog-ls --rules_config_search`
- **Root markers:** `.git`, `verible.filelist`
- **File types:** `verilog`, `systemverilog`

### Diagnostic Display

- ✓ Virtual text (inline messages)
- ✓ Signs in gutter (icons)
- ✓ Underlines
- ✓ Update on insert disabled
- ✓ Severity sorting enabled

### Diagnostic Signs

- **Error:** ` ` (red)
- **Warning:** ` ` (yellow)
- **Hint:** ` ` (blue)
- **Info:** ` ` (cyan)

---

## Special Features

### Verible Auto File List Generation

**Automatically generates `verible.filelist` when:**
- Opening any `.sv`, `.svh`, `.v`, or `.vh` file
- Files have changed since last generation
- Smart comparison prevents unnecessary regeneration

**Manual trigger:** `,vf` or `:VeribleGenerateFileList`

**Behavior:**
- Searches project root (`.git` or current directory)
- Finds all SystemVerilog/Verilog files recursively
- Creates sorted list in `verible.filelist`
- Automatically restarts LSP to pick up changes
- Shows notification with file count

### Diagnostic Toggle

Press `,td` to toggle ALL diagnostic displays:
- Virtual text (inline error messages)
- Signs in gutter
- Underlines
- Diagnostic highlights

Useful for focusing on code without distractions.

### Auto-Format Toggle

Press `,tf` to toggle automatic formatting on save:
- **Default state:** OFF (disabled)
- **When enabled:** Code is automatically formatted when saving SystemVerilog files
- **When disabled:** Manual format still available with `,lf`
- **Per-session:** Toggle state resets to OFF when restarting NeoVim

**Rationale:** Auto-format is disabled by default to avoid disrupting team workflows where:
- Not everyone uses the same formatter
- Working with legacy code that hasn't been formatted
- Different formatting standards across projects

---

## Quick Reference Card

### Most Common Operations

| Task | Keys | Alternative |
|------|------|-------------|
| **Find file** | `,ff` | `:Telescope find_files` |
| **Search in files** | `,fg` | `:Telescope live_grep` |
| **Go to definition** | `gd` | - |
| **Show error details** | `,d` | - |
| **Format code** | `,lf` | Manual format anytime |
| **Toggle auto-format** | `,tf` | Enable/disable format on save |
| **Rename symbol** | `,lr` | - |
| **Next buffer** | `Tab` | `:BufferLineCycleNext` |
| **File tree** | `,e` | `:NvimTreeToggle` |
| **Toggle diagnostics** | `,td` | - |

---

## Workflow Examples

### Working with SystemVerilog

1. **Open a project:**
   - `nvim project/top.sv`
   - Wait for LSP to attach
   - `verible.filelist` generated automatically

2. **Navigate code:**
   - Cursor on module name → `gd` to see definition
   - `gr` to see all instantiations
   - `K` to see module interface

3. **Fix errors:**
   - See red underline → `,d` for details
   - `Ctrl-j` to jump to next error
   - Fix and `,lf` to format manually

4. **Refactor:**
   - Cursor on signal → `,lr` to rename everywhere
   - `,lf` to format if needed

5. **Working alone on formatted code:**
   - Press `,tf` to enable auto-format on save
   - Save files → automatic formatting applies
   - Press `,tf` again to disable when working with team

### File Navigation

1. **Find file:** `,ff` → type partial name → Enter
2. **Search text:** `,fg` → type search term → Enter
3. **Switch buffer:** `Tab` / `Shift-Tab`
4. **Close buffer:** `,bc` → select buffer

### Using File Explorer

1. **Open tree:** `,e`
2. **Navigate:** `j`/`k` (up/down)
3. **Actions:** `a` (create), `d` (delete), `r` (rename)
4. **Change root:** `+` on directory
5. **Close tree:** `,e` again

---

## Notes

### Spanish Keyboard Compatibility

Standard Vim mappings `[d` and `]d` (next/previous diagnostic) have been replaced with:
- `Ctrl-k` - Previous diagnostic
- `Ctrl-j` - Next diagnostic

This avoids the awkward `AltGr+[` combinations on Spanish keyboards.

### Telescope vs LSP Format Conflict

The `,f` mapping has been avoided to prevent delays with Telescope's `,ff`, `,fg`, etc.
LSP formatting uses `,lf` instead (LSP format).

### Auto-Format Behavior

**Default:** Auto-format on save is **DISABLED** by default.

**To enable:** Press `,tf` (toggle format). A notification will confirm the state.

**Manual format:** Always available with `,lf` regardless of auto-format state.

**Why disabled by default?**
- Prevents disruption in team environments
- Avoids conflicts with different formatting standards
- Gives you control over when formatting happens
- Legacy code may not be ready for auto-formatting

The toggle state is per-session and resets to OFF when you restart NeoVim.

---

## Configuration Files

### Main Configuration
- **Path:** `~/.config/nvim/init.lua`
- **Contents:** Core settings, plugin definitions, general keybindings

### LSP Configuration (Modular)
- **Path:** `~/.config/nvim/lua/lsp-config.lua`
- **Contents:** LSP setup, Verible configuration, diagnostic settings, auto-generation, format toggle
- **Loading:** Conditionally loaded with `pcall`, won't error if missing

### Project-Level Configuration
- **Verible rules:** `.rules.verible_lint` (searched in parent directories)
- **File list:** `verible.filelist` (auto-generated at project root)

---

## Troubleshooting

### Check LSP Status
```vim
:LspInfo
```

### Regenerate File List
```vim
:VeribleGenerateFileList
```
or press `,vf`

### Check Health
```vim
:checkhealth
:checkhealth vim.lsp
```

### Restart LSP
```vim
:LspRestart verible
```

### View Logs
```vim
:lua vim.cmd('edit ' .. vim.lsp.get_log_path())
```

### Check Auto-Format State
The notification when you toggle (`,tf`) shows the current state.
Auto-format is OFF by default each time you start NeoVim.

---

## Version Information

- **NeoVim:** 0.11+ recommended (uses new `vim.lsp.config` and `vim.lsp.enable` APIs)
- **Verible:** Latest version from GitHub releases
- **Configuration:** Modular Lua-based setup with lazy.nvim

---

*This reference guide corresponds to the init.lua and lsp-config.lua created on February 16, 2026.*
