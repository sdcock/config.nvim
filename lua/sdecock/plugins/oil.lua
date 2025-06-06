return {
  {
    'stevearc/oil.nvim',
    opts = {
      columns = {
        'icon',
        'size',
        'mtime',
      },
      keymaps = {
        ['<C-h>'] = false,
      },
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        case_insensitive = true,
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
