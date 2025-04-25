vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.number = true
--vim.opt.relativenumber = true
vim.cmd("filetype plugin indent on") -- Enable filetype-specific indentation

vim.g.mapleader = " "


vim.opt.makeprg = "cmake --build build"

-- Basic commands
vim.api.nvim_create_user_command("CMakeGenerate", "!cmake -S . -B build", {})
vim.api.nvim_create_user_command("CMakeBuild", "!cmake --build build", {})
vim.api.nvim_create_user_command("CMakeRun", "!./build/myapp", {})

vim.api.nvim_set_keymap('n', ',cc', '<Plug>NERDCommenterToggle', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', ',cc', '<Plug>NERDCommenterComment', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', ',cu', '<Plug>NERDCommenterUncomment', { noremap = true, silent = true })

