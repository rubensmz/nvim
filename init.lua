-- Define the Vimscript command to initialize vim-plug
vim.cmd([[
  call plug#begin('~/.local/share/nvim/plugged')

  " List your plugins here, for example:
  " Plug 'tpope/vim-sensible'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  call plug#end()
]])

vim.g.mapleader = ","

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
