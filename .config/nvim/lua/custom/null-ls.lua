return {
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function()
      require('mason-null-ls').setup {
        ensure_installed = {
          'stylua',
          'jq',
          'black',
          'prettier',
          'shfmt',
          'gofumpt',
          'goimports',
          'golines',
        },
        automatic_installation = false,
        automatic_setup = true,
        handlers = {},
      }
      require('null-ls').setup {
        sources = {},
      }
    end,
  },
}
