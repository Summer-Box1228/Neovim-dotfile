vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4

vim.g.netrw_keepdir = 0

vim.lsp.enable('clangd')
-- Define the configuration for rust-analyzer
vim.lsp.config.rust_analyzer = {
    cmd = { 'rust-analyzer' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    filetypes = { 'rust' },
}

-- Enable the server
vim.lsp.enable('rust_analyzer')

vim.lsp.config.lua_ls = {
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    filetypes = { 'lua' },
}
vim.lsp.enable('lua_ls')

require("p").setup()
vim.keymap.set("n", "<leader>ds", require("p").do_something)
