-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set Python provider
-- https://vi.stackexchange.com/a/44819
vim.g.python3_host_prog = vim.fn.expand("~/venvs/neovim/bin/python")
