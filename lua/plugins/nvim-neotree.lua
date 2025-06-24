return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module "neo-tree"
    ---@type neotree.Config?
    opts = {
        -- fill any relevant options here
    },
    config = function()
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {});
        local utils = require("utils.copy_folder")

        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true,         -- Show hidden files by default
                    show_hidden_count = true,
                    hide_dotfiles = false,  -- Show dotfiles (like .git, .env)
                    hide_gitignored = false, -- Show files ignored by .gitignore
                },
            },
            window = {
                mappings = {
                    ["C"] = function(state)
                        local node = state.tree:get_node()
                        if node and node.type == "directory" then
                            utils.copy_folder_with_destination(node.path)
                        else
                            print("Not a directory")
                        end
                    end,
                },
            },
        })
    end
}
