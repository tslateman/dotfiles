-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Python specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- LSP
    vim.keymap.set("n", "<leader>pd", vim.lsp.buf.definition, { buffer = true, desc = "Go to Definition" })
    vim.keymap.set("n", "<leader>pr", vim.lsp.buf.references, { buffer = true, desc = "Find References" })
    vim.keymap.set("n", "<leader>pn", vim.lsp.buf.rename, { buffer = true, desc = "Rename Symbol" })
    
    -- Testing
    vim.keymap.set("n", "<leader>pt", "<cmd>lua require('neotest').run.run()<cr>", { buffer = true, desc = "Run Test" })
    vim.keymap.set("n", "<leader>ps", "<cmd>lua require('neotest').summary.toggle()<cr>", { buffer = true, desc = "Toggle Test Summary" })
    
    -- Debugging
    vim.keymap.set("n", "<leader>pb", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { buffer = true, desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>pc", "<cmd>lua require('dap').continue()<cr>", { buffer = true, desc = "Continue/Start Debug" })
    vim.keymap.set("n", "<leader>po", "<cmd>lua require('dap').step_over()<cr>", { buffer = true, desc = "Step Over" })
    vim.keymap.set("n", "<leader>pi", "<cmd>lua require('dap').step_into()<cr>", { buffer = true, desc = "Step Into" })
    
    -- Formatting
    vim.keymap.set("n", "<leader>pf", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = true, desc = "Format File" })
  end,
})
