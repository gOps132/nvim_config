local M = {}

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.create_project_from_template(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)

    if not selection then
        print("No template selected")
        return
    end

    local template_name = selection[1]
    local new_name = vim.fn.input("Enter new project name: ")
    if new_name == "" then
        print("No name provided, aborting")
        return
    end

    local default_dest = vim.fn.getcwd()
    local dest_path = vim.fn.input("Enter destination path [" .. default_dest .. "]: ")
    if dest_path == "" then
        dest_path = default_dest
    end

    if vim.fn.isdirectory(dest_path) == 0 then
        vim.fn.mkdir(dest_path, "p")
    end

    local source_dir = vim.fn.getcwd() .. "/template/" .. template_name
    local dest_dir = dest_path .. "/" .. new_name

    if vim.fn.isdirectory(dest_dir) == 1 then
        print("Directory " .. dest_dir .. " already exists")
        return
    end

    vim.fn.system({ "cp", "-r", source_dir, dest_dir })
    if vim.v.shell_error ~= 0 then
        print("Failed to copy template: " .. template_name)
        return
    end

    local cmake_file = dest_dir .. "/CMakeLists.txt"
    if vim.fn.filereadable(cmake_file) == 1 then
        local content = vim.fn.readfile(cmake_file)
        for i, line in ipairs(content) do
            content[i] = line:gsub("SimpleTemplate", new_name)
        end
        vim.fn.writefile(content, cmake_file)
    end

    local root_cmake_file = vim.fn.getcwd() .. "/CMakeLists.txt"
    if vim.fn.filereadable(root_cmake_file) == 1 then
        local relative_path = vim.fn.fnamemodify(dest_dir, ":.:")
        local cmake_content = vim.fn.readfile(root_cmake_file)
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

-- New function to create project from an existing CMake project
function M.create_project_from_existing_project(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)

    if not selection then
        print("No project selected")
        return
    end

    local source_dir = selection.path or selection[1]
    local new_name = vim.fn.input("Enter new project name: ")
    if new_name == "" then
        print("No name provided, aborting")
        return
    end

    local default_dest = vim.fn.getcwd()
    local dest_path = vim.fn.input("Enter destination path [" .. default_dest .. "]: ")
    if dest_path == "" then
        dest_path = default_dest
    end

    if vim.fn.isdirectory(dest_path) == 0 then
        vim.fn.mkdir(dest_path, "p")
    end

    local dest_dir = dest_path .. "/" .. new_name

    if vim.fn.isdirectory(dest_dir) == 1 then
        print("Directory " .. dest_dir .. " already exists")
        return
    end

    -- Copy the existing project to the new destination
    vim.fn.system({ "cp", "-r", source_dir, dest_dir })
    if vim.v.shell_error ~= 0 then
        print("Failed to copy project: " .. source_dir)
        return
    end

    -- Modify CMakeLists.txt inside the destination folder
    local cmake_file = dest_dir .. "/CMakeLists.txt"
    if vim.fn.filereadable(cmake_file) == 1 then
        local content = vim.fn.readfile(cmake_file)
        for i, line in ipairs(content) do
            content[i] = line:gsub(vim.fn.fnamemodify(source_dir, ":t"), new_name)
        end
        vim.fn.writefile(content, cmake_file)
    end

    print("Created new project: " .. new_name .. " from existing project " .. source_dir .. " at " .. dest_dir)
    vim.cmd("edit " .. cmake_file)
end

return M

