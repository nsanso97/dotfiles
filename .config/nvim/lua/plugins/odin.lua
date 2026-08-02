return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "odin" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ols = {
          mason = false,
          cmd = { "ols" },
          settings = { odin_command = "odin" },
        },
      },
    },
  },
}
