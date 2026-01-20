
-- Better colors & always show tabline (bufferline lives here)
vim.opt.termguicolors = true
vim.opt.showtabline = 2

-- Set relative numbers
vim.opt.relativenumber = true
-- Show absolute line number for current line
vim.opt.number = true
-- Use spaces instead of <Tab>
vim.opt.expandtab = true
-- Visual width of a tab character
vim.opt.tabstop = 3
-- Indent size for >>, <<, autoindent, etc.
vim.opt.shiftwidth = 3
-- How many spaces <Tab> inserts in insert mode
vim.opt.softtabstop = 3
-- Use comma as leader key
vim.g.mapleader = ","
-- Normal mode: Space starts a forward search
vim.keymap.set("n", "<Space>", "/", { noremap = true, silent = false })
-- Case-insensitive by default...
vim.o.ignorecase = true
-- ...but if the search pattern has any uppercase letter, make it case-sensitive
vim.o.smartcase = true
-- Clear search highlight
vim.keymap.set("n", "<leader><CR>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })


if vim.g.vscode then
   -- Running inside VS Code
   -- VSCode-specific config here
else
   -- Plain Neovim

   -- Bootstrap lazy.nvim
   local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
   local uv = vim.uv or vim.loop
   if not uv.fs_stat(lazypath) then
      vim.fn.system({
         "git",
         "clone",
         "--filter=blob:none",
         "https://github.com/folke/lazy.nvim.git",
         "--branch=stable",
         lazypath,
      })
   end
   vim.opt.rtp:prepend(lazypath)

   -- Plugins
   require("lazy").setup({
      -- Telescope + dependency
      {
         "nvim-telescope/telescope.nvim",
         dependencies = { "nvim-lua/plenary.nvim" },
      },

      -- Perforce
      { "nfvs/vim-perforce" },

      -- Theme (load early, don't lazy-load)
      {
         "catppuccin/nvim",
         name = "catppuccin",
         lazy = false,
         priority = 1000,
         config = function()
            vim.cmd.colorscheme("catppuccin-mocha")
         end,
      },

      -- File explorer
      {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
          "nvim-tree/nvim-web-devicons", -- icons
        },
        config = function()
          require("nvim-tree").setup({})
        end,
      },

      -- Statusline
      {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional icons
        config = function()
          require("lualine").setup({
            options = {
              theme = "catppuccin",
              icons_enabled = true,
              globalstatus = true, -- single statusline across splits (nvim >= 0.7)

              section_separators = { left = "", right = "" },
              component_separators = "",
            },
          })
        end,
        extensions = { "quickfix", "nvim-tree", "toggleterm", "lazy" },
      },

      -- Bufferline: show buffers in the tabline (top bar)
      {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("bufferline").setup({
            options = {
              mode = "buffers",                 -- show buffers, not tabs
              always_show_bufferline = true,
              show_buffer_close_icons = false,
              show_close_icon = false,
              separator_style = "slant",        -- "slant" | "thin" | "padded_slant" | etc.
              diagnostics = false,              -- set to "nvim_lsp" if you want LSP diagnostics
              offsets = {
                { filetype = "NvimTree", text = "Explorer", text_align = "left" },
              },
            },
          })

          -- Keymaps: cycle buffers with Tab / Shift-Tab
          vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
          vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true, desc = "Prev buffer" })
        end,
      },
   }) -- plugin spec format and setup are per lazy.nvim docs [web:1][web:51]

   require("catppuccin").setup({
      auto_integrations = true,
   })

   -- Disable netrw
   vim.g.loaded_netrw = 1
   vim.g.loaded_netrwPlugin = 1

   -- nvim-tree keymaps
   vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
   vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal current file in tree" })

   -- Configure Telescope (safe to require after lazy.setup)
   local builtin = require("telescope.builtin")
   vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
   vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Telescope live grep" })
   vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Telescope buffers" })
   vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Telescope help tags" })
end
