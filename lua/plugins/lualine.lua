return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'dracula'
--          component_separators = { left = '', right = ''},  -- Pointy separators
--          section_separators = { left = '', right = ''},  -- Pointy block separators 
        }
      })
    end
}
