return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        -- Your existing keymaps
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})


        local function create_project_from_template(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)

            if not selection then
                print("No template selected")
                return
            end

            local template_name = selection[1]  -- Directory name from Telescope
            local new_name = vim.fn.input("Enter new project name: ")
            if new_name == "" then
                print("No name provided, aborting")
                return
            end

            -- Prompt for destination directory (defaults to current working directory)
            local default_dest = vim.fn.getcwd()
            local dest_path = vim.fn.input("Enter destination path [" .. default_dest .. "]: ")
            if dest_path == "" then
                dest_path = default_dest
            end

            -- Ensure the destination path exists or create it
            if vim.fn.isdirectory(dest_path) == 0 then
                vim.fn.mkdir(dest_path, "p")  -- 'p' creates parent directories as needed
            end

            local source_dir = vim.fn.getcwd() .. "/template/" .. template_name
            local dest_dir = dest_path .. "/" .. new_name

            -- Check if destination already exists
            if vim.fn.isdirectory(dest_dir) == 1 then
                print("Directory " .. dest_dir .. " already exists")
                return
            end

            -- Copy directory
            vim.fn.system("cp -r " .. source_dir .. " " .. dest_dir)
            if vim.v.shell_error ~= 0 then
                print("Failed to copy template: " .. template_name)
                return
            end

            -- Rename in CMakeLists.txt
            local cmake_file = dest_dir .. "/CMakeLists.txt"
            if vim.fn.filereadable(cmake_file) == 1 then
                local content = vim.fn.readfile(cmake_file)
                for i, line in ipairs(content) do
                    content[i] = line:gsub("SimpleTemplate", new_name)
                end
                vim.fn.writefile(content, cmake_file)
            end

            -- Add subdirectory to main CMakeLists.txt
            local root_cmake_file = vim.fn.getcwd() .. "/CMakeLists.txt"
            if vim.fn.filereadable(root_cmake_file) == 1 then
                local relative_path = vim.fn.fnamemodify(dest_dir, ":.:")  -- Get relative path from myproject/
                local cmake_content = vim.fn.readfile(root_cmake_file)
                -- Check if the subdirectory is already added to avoid duplicates
                local already_added = false
                for _, line in ipairs(cmake_content) do
                    if line:match("add_subdirectory%(" .. relative_path .. "%)") then
                        already_added = true
                        break
                    end
                end
                if not already_added then
                    table.insert(cmake_content, "add_subdirectory(" .. relative_path .. ")")
                    vim.fn.writefile(cmake_content, root_cmake_file)
                    print("Added 'add_subdirectory(" .. relative_path .. ")' to " .. root_cmake_file)
                end
            else
                print("Root CMakeLists.txt not found, skipping add_subdirectory")
            end

            print("Created new project: " .. new_name .. " from " .. template_name .. " at " .. dest_dir)
            vim.cmd("edit " .. cmake_file)
        end

        -- Setup Telescope with default config (no global CR override!)
        require("telescope").setup({
            defaults = {
                -- No global <CR> mapping override here
            },
            pickers = {
                find_files = {},
            },
        })
    end,

    keys = {
        {
            "<leader>ct",
            function()
                require("telescope.builtin").find_files({
                    prompt_title = "Select Template",
                    cwd = vim.fn.getcwd() .. "/template",
                    find_command = { "find", ".", "-maxdepth", "1", "-type", "d" }, -- List directories only
                    attach_mappings = function(_, map)
                        map("i", "<CR>", function(prompt_bufnr)
                            local actions = require("telescope.actions")
                            local action_state = require("telescope.actions.state")
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            if selection then
                                vim.schedule(function()
                                    create_project_from_template(prompt_bufnr)
                                end)
                            end
                        end)
                        map("n", "<CR>", function(prompt_bufnr)
                            local actions = require("telescope.actions")
                            local action_state = require("telescope.actions.state")
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            if selection then
                                vim.schedule(function()
                                    create_project_from_template(prompt_bufnr)
                                end)
                            end
                        end)
                        return true
                    end,
                })
            end,
            desc = "Create from Template"
        },
    },
}

