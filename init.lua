-- Set relative numbers
vim.opt.relativenumber = true
-- Show absolute line number for current line
vim.opt.number = true
-- Use spaces instead of <Tab>
vim.opt.expandtab   = true  
-- Visual width of a tab character
vim.opt.tabstop     = 3     
-- Indent size for >>, <<, autoindent, etc.
vim.opt.shiftwidth  = 3     
-- How many spaces <Tab> inserts in insert mode
vim.opt.softtabstop = 3     
-- Use comma a leader key
vim.g.mapleader = ","
-- Normal mode: Space starts a forward search
vim.keymap.set("n", "<Space>", "/", { noremap = true, silent = false })

if vim.g.vscode then
	-- Running inside VS Code
	-- VSCode-specific config here
else
	-- Plain NeoVim
	-- Define the Vimscript command to initialize vim-plug
	vim.cmd([[
	  call plug#begin('~/.local/share/nvim/plugged')

	  " List your plugins here, for example:
	  " Plug 'tpope/vim-sensible'
	  Plug 'dracula/vim', { 'as': 'dracula' }
	  Plug 'nvim-lua/plenary.nvim'
	  Plug 'nvim-telescope/telescope.nvim'
      Plug 'nfvs/vim-perforce'
	  call plug#end()
	]])

	-- Configure Telescope
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
	vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

	-- Configure Dracula as theme
	vim.cmd('colorscheme dracula')

end
