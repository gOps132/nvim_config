return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim", 
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "jdtls" } -- Add clangd for C++
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Lua language server setup
      lspconfig.lua_ls.setup({})

      -- C++ (Clangd) language server setup
      lspconfig.clangd.setup({
        cmd = { "clangd", "--background-index", "--clang-tidy" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
      })

      lspconfig.jdtls.setup({
          cmd = { "jdtls" },
          root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
      })

      -- Common keybindings for LSP
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover info" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

    end
  }
}

