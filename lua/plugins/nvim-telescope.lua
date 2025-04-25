return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

        require("telescope").setup({
            defaults = {},
            pickers = {
                find_files = {},
            },
        })
    end,

    keys = {
        {
            "<leader>ct",
            function()
                local template_utils = require("utils.create_template")
                require("telescope.builtin").find_files({
                    prompt_title = "Select Template",
                    cwd = vim.fn.getcwd() .. "/template",
                    find_command = { "find", ".", "-mindepth", "1", "-maxdepth", "1", "-type", "d" },
                    attach_mappings = function(_, map)
                        map("i", "<CR>", function(bufnr)
                            vim.schedule(function()
                                template_utils.create_project_from_template(bufnr)
                            end)
                        end)
                        map("n", "<CR>", function(bufnr)
                            vim.schedule(function()
                                template_utils.create_project_from_template(bufnr)
                            end)
                        end)
                        return true
                    end,
                })
            end,
            desc = "Create from Template",
        },
        {
            "<leader>ctp",
            function()
                local template_utils = require("utils.create_template")
                require("telescope.builtin").find_files({
                    prompt_title = "Select Template",
                    cwd = vim.fn.getcwd() .. "/template",
                    find_command = { "find", ".", "-mindepth", "1", "-maxdepth", "1", "-type", "d" },
                    attach_mappings = function(_, map)
                        map("i", "<CR>", function(bufnr)
                            vim.schedule(function()
                                template_utils.create_project_from_project(bufnr)
                            end)
                        end)
                        map("n", "<CR>", function(bufnr)
                            vim.schedule(function()
                                template_utils.create_project_from_project(bufnr)
                            end)
                        end)
                        return true
                    end,
                })
            end,
            desc = "Create cmake project from existing project",
        },
    },
}

