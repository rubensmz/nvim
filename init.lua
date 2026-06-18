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
-- Auto-checkout file from Perforce when first modified (FileChangedRO event)
vim.g.perforce_open_on_change = 1
-- Auto-checkout file from Perforce when saving a read-only file (:w!)
vim.g.perforce_open_on_save = 1
-- Skip confirmation prompt and checkout immediately
vim.g.perforce_prompt_on_open = 0
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

-- Filetype detection for SystemVerilog/Verilog
vim.filetype.add({
   extension = {
      v = 'verilog',
      sv = 'systemverilog',
      svh = 'systemverilog',
   },
})

if vim.g.vscode then
   -- Running inside VS Code
   -- VSCode-specific config here
else
   -- Plain Neovim

   -- Disable netrw early (before plugin loading)
   vim.g.loaded_netrw = 1
   vim.g.loaded_netrwPlugin = 1

   -- Bootstrap lazy.nvim (use local disk to avoid NFS latency)
   local lazy_base = "/tmp/" .. (os.getenv("USER") or "nvim") .. "/nvim"
   local lazypath = lazy_base .. "/lazy/lazy.nvim"
   local uv = vim.uv or vim.loop
   if not uv.fs_stat(lazypath) then
      vim.fn.mkdir(lazy_base .. "/lazy", "p")
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

   -- ShaDa, swap, and undo on local disk
   vim.opt.shadafile = lazy_base .. "/shada/main.shada"
   vim.fn.mkdir(lazy_base .. "/shada", "p")
   vim.opt.directory = lazy_base .. "/swap//"
   vim.fn.mkdir(lazy_base .. "/swap", "p")
   vim.opt.undodir = lazy_base .. "/undo//"
   vim.fn.mkdir(lazy_base .. "/undo", "p")

   -- Plugins
   local lazy_root = "/tmp/" .. (os.getenv("USER") or "nvim") .. "/nvim/lazy"
   vim.fn.mkdir(lazy_root, "p")

   require("lazy").setup({

      -- Telescope + dependency
      {
         "nvim-telescope/telescope.nvim",
         cmd = "Telescope",
         keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Telescope live grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Telescope buffers" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Telescope help tags" },
         },
         dependencies = { "nvim-lua/plenary.nvim" },
         config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
               defaults = {
                  find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
                  vimgrep_arguments = {
                     "rg", "--color=never", "--no-heading", "--with-filename",
                     "--line-number", "--column", "--smart-case", "--hidden",
                     "--glob", "!.git/",
                  },
                  mappings = {
                     n = {
                        ["dd"] = actions.delete_buffer,
                     },
                     i = {
                        ["<C-d>"] = actions.delete_buffer,
                     },
                  },
               },
               pickers = {
                  find_files = {
                     find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
                  },
               },
            })
         end
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
            require("catppuccin").setup({
               default_integrations = false,
               integrations = {
                  bufferline = true,
                  nvimtree = true,
                  telescope = true,
                  treesitter = true,
                  lsp_trouble = true,
                  native_lsp = { enabled = true },
               },
               highlight_overrides = {
                  mocha = function(mocha)
                     return {
                        WinSeparator              = { fg = mocha.surface1 },
                        FloatBorder               = { fg = mocha.surface1 },
                        -- Bufferline slant separators
                        BufferLineSeparator         = { fg = mocha.surface1 },
                        BufferLineSeparatorSelected = { fg = mocha.surface1, bg = mocha.surface0 },
                        BufferLineSeparatorVisible  = { fg = mocha.surface1 },
                        BufferLineOffsetSeparator   = { fg = mocha.surface1 },
                        -- Bufferline backgrounds
                        BufferLineBufferSelected    = { fg = mocha.text,    bg = mocha.surface0 },
                        -- Bufferline empty background
                        BufferLineFill              = { bg = mocha.surface1 },
                        -- NvimTree border
                        NvimTreeOffset       = { fg = mocha.base, bg = mocha.surface1 },
                        NvimTreeWinSeparator = { fg = mocha.surface1, bg = mocha.base }, 
                     }
                  end,
               },
            })
            vim.cmd.colorscheme("catppuccin-mocha")
         end,
      },

      -- File explorer
      {
         "nvim-tree/nvim-tree.lua",
         version = "*",
         cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
         keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
            { "<leader>o", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file in tree" },
         },
         dependencies = {
            "nvim-tree/nvim-web-devicons", -- icons
         },
         config = function()
            require("nvim-tree").setup({
               hijack_directories = { enable = false },
               git = { enable = false },
               on_attach = function(bufnr)
                  local api = require("nvim-tree.api")

                  -- Load all default keybindings first
                  api.config.mappings.default_on_attach(bufnr)
                  -- Use + to change root to the directory under cursor
                  vim.keymap.set('n', '+', api.tree.change_root_to_node, {
                     buffer = bufnr,
                     desc = 'Change root to node'
                  })
               end,

            })
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

                  section_separators = { left = "", right = "" },
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
                  diagnostics = "nvim_lsp",         -- show LSP diagnostics in bufferline
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



   }, {
      root = lazy_root,
      lockfile = lazy_base .. "/lazy-lock.json",
      performance = {
         rtp = {
            disabled_plugins = {
               "gzip",
               "matchit",
               "matchparen",
               "netrwPlugin",
               "tarPlugin",
               "tohtml",
               "tutor",
               "zipPlugin",
            },
         },
      },
   }) -- plugin spec format and setup are per lazy.nvim docs

   -- Choose what buffer close with <leader>bc
   vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
end

