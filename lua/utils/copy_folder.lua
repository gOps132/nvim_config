local M = {}

function M.copy_folder_with_destination(source_path)
    local telescope = require("telescope.builtin")
    local action_state = require("telescope.actions.state")
    local actions = require("telescope.actions")

    telescope.find_files({
        prompt_title = "Select Destination Directory",
        cwd = vim.fn.getcwd(),
        find_command = { "fd", "--type", "d", "--max-depth", "4" }, -- or use `find` if `fd` is not available
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                if selection then
                    local dest_dir = selection.path or selection[1]
                    local suggested_name = vim.fn.fnamemodify(source_path, ":t")
                    local new_name = vim.fn.input("New folder name [" .. suggested_name .. "]: ")

                    if new_name == "" then
                        new_name = suggested_name
                    end

                    local full_dest = dest_dir .. "/" .. new_name
                    vim.fn.system({ "cp", "-r", source_path, full_dest })

                    if vim.v.shell_error == 0 then
                        print("Copied to: " .. full_dest)
                    else
                        print("Failed to copy folder.")
                    end
                end
            end)

            return true
        end,
    })
end

return M

