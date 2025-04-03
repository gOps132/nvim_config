vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "


vim.opt.makeprg = "cmake --build build"

-- Basic commands
vim.api.nvim_create_user_command("CMakeGenerate", "!cmake -S . -B build", {})
vim.api.nvim_create_user_command("CMakeBuild", "!cmake --build build", {})
vim.api.nvim_create_user_command("CMakeRun", "!./build/myapp", {})
