-- ============================================================================
-- LSP Configuration Module
-- ============================================================================

local M = {}

function M.setup()
   -- Configure Verible LSP using the new vim.lsp.config API
   vim.lsp.config.verible = {
      cmd = {'verible-verilog-ls', '--rules_config_search'},
      root_markers = {'.git', 'verible.filelist'},
      filetypes = {'verilog', 'systemverilog'},
   }

   -- Enable Verible LSP
   vim.lsp.enable('verible')

   -- Set up LSP keybindings using LspAttach autocmd
   vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
         local bufnr = args.buf
         local opts = { buffer = bufnr, noremap = true, silent = true }

         -- Essential navigation
         vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
         vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
         vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
         vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

         -- Documentation
         vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

         -- Code editing (using ,l prefix to avoid conflicts)
         vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP rename" })
         vim.keymap.set('n', '<leader>lf', function() 
            vim.lsp.buf.format({ async = true }) 
         end, { buffer = bufnr, desc = "LSP format" })
         vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP code action" })

         -- Conditional auto-format on save (respects toggle)
         vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
               if M.is_autoformat_enabled() then
                  vim.lsp.buf.format({ bufnr = bufnr, async = false })
               end
            end,
         })
      end,
   })

   -- Configure diagnostic display
   vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
   })

   -- Diagnostic signs in the gutter
   local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
   for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
   end

   -- ============================================================================
   -- Verible Auto File List Generation
   -- ============================================================================

   local function generate_verible_filelist_smart()
      local root_dir = vim.fs.root(0, {'.git', 'verible.filelist'}) or vim.fn.getcwd()
      local filelist_path = root_dir .. '/verible.filelist'

      -- Get current SystemVerilog files
      local handle = io.popen('cd ' .. vim.fn.shellescape(root_dir) .. 
      ' && find . -type f \\( -name "*.sv" -o -name "*.svh" -o -name "*.v" -o -name "*.vh" \\) 2>/dev/null | sort')

      if not handle then
         vim.notify('Failed to search for SystemVerilog files', vim.log.levels.ERROR)
         return
      end

      local current_files = handle:read("*a")
      handle:close()

      if current_files == "" or current_files == nil then
         return -- No files found, skip silently
      end

      -- Check if filelist exists and compare
      local file = io.open(filelist_path, "r")
      local needs_update = true

      if file then
         local existing_content = file:read("*a")
         file:close()
         needs_update = (existing_content ~= current_files)
      end

      if needs_update then
         -- Write new file list
         local output = io.open(filelist_path, "w")
         if output then
            output:write(current_files)
            output:close()

            -- Count files
            local _, file_count = current_files:gsub('\n', '\n')
            vim.notify('Updated verible.filelist (' .. file_count .. ' files)', vim.log.levels.INFO)

            -- Restart LSP to pick up changes (only if LSP is running)
            local clients = vim.lsp.get_clients({ name = 'verible' })
            if #clients > 0 then
               vim.cmd('LspRestart verible')
            end
         else
            vim.notify('Failed to write verible.filelist', vim.log.levels.ERROR)
         end
      end
   end

   -- Auto-generate on opening SystemVerilog files
   vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = {"*.sv", "*.svh", "*.v", "*.vh"},
      group = vim.api.nvim_create_augroup("VeribleAutoGenerate", { clear = true }),
      callback = function()
         -- Defer to avoid blocking file opening
         vim.defer_fn(generate_verible_filelist_smart, 100)
      end,
   })

   -- Create user command
   vim.api.nvim_create_user_command('VeribleGenerateFileList', generate_verible_filelist_smart, {
      desc = 'Generate or update verible.filelist for the current project'
   })

   -- Keybinding: ,vf to generate Verible file list
   vim.keymap.set('n', '<leader>vf', ':VeribleGenerateFileList<CR>', 
   { desc = 'Generate Verible file list', silent = true })

   -- ============================================================================
   -- Toggle LSP Diagnostics
   -- ============================================================================

   local diagnostics_active = true

   local function toggle_diagnostics()
      diagnostics_active = not diagnostics_active

      if diagnostics_active then
         vim.diagnostic.enable()
         vim.notify("Diagnostics enabled", vim.log.levels.INFO)
      else
         vim.diagnostic.disable()
         vim.notify("Diagnostics disabled", vim.log.levels.INFO)
      end
   end

   vim.keymap.set('n', '<leader>td', toggle_diagnostics, { desc = "Toggle diagnostics" })
   -- ============================================================================
   -- Toggle Auto-Format on Save
   -- ============================================================================

   local autoformat_enabled = false  -- Start disabled by default

   local function toggle_autoformat()
      autoformat_enabled = not autoformat_enabled

      if autoformat_enabled then
         vim.notify("Auto-format on save enabled", vim.log.levels.INFO)
      else
         vim.notify("Auto-format on save disabled", vim.log.levels.INFO)
      end
   end

   vim.keymap.set('n', '<leader>tf', toggle_autoformat, { desc = "Toggle auto-format on save" })

   -- Export the state for use in LspAttach
   M.is_autoformat_enabled = function()
      return autoformat_enabled
   end

   -- ============================================================================
   -- Global LSP Keymaps
   -- ============================================================================

   -- Note: Using Ctrl-j/k instead of ]d/[d for Spanish keyboard compatibility
   vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "Show diagnostics" })
   vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
   vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
   vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
end

return M

