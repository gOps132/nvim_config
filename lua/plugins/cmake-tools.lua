-- lua/plugins/cmake.lua
return {
  {
    "Civitasv/cmake-tools.nvim",
    ft = {"cmake"},
    opts = {
      cmake_command = "cmake",
      cmake_build_directory = "${workspaceFolder}/build",
      cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_soft_link_compile_commands = true,
      cmake_build_directory_prefix = "",
    },
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
      { "<leader>cr", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
      { "<leader>cs", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select Target" },
      { "<leader>cl", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select Launch Target" }
    },
    config = function(_, opts)
      require("cmake-tools").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").cmake.setup {}
    end,
  },
}
