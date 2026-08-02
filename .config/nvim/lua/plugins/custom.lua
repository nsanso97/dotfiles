return {
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "catppuccin/nvim",
    opts = {
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          -- Make floating windows transparent with a visible border
          NormalFloat = { bg = "none" },
          FloatBorder = { fg = colors.mantle, bg = "none" },

          -- Fix telescope transparency if it renders too dark
          TelescopeNormal = { bg = "none" },
          TelescopeBorder = { bg = "none" },

          -- Optional: keep neo-tree or sidebars slightly dark for contrast
          NeoTreeNormal = { bg = "none" },
          NeoTreeNormalNC = { bg = "none" },
        }
      end,
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
  {
    "folke/snacks.nvim",
    opts = {
      image = { enabled = true },
      picker = {
        layouts = {
          sidebar = {
            layout = {
              position = "right",
            },
          },
        },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
          files = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = { cmdline = { view = "cmdline" } },
  },
  {
    "saghen/blink.cmp",
    opts = { keymap = { preset = "super-tab" } },
  },
}
