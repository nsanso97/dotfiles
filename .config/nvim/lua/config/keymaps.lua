-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 1. Safely unmap LazyVim's default terminal hotkeys
vim.keymap.del("n", "<C-/>")
vim.keymap.del("t", "<C-/>")
vim.keymap.del("n", "<C-_>")
vim.keymap.del("t", "<C-_>")

-- 2. Map Ctrl + / to act like 'gcc' in Normal Mode (remap = true is required)
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Comment line" })
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Comment line" })

-- 3. Map Ctrl + / to act like 'gc' in Visual Mode (remap = true is required)
vim.keymap.set("x", "<C-/>", "gc", { remap = true, desc = "Comment selection" })
vim.keymap.set("x", "<C-_>", "gc", { remap = true, desc = "Comment selection" })

-- 4. Toggle background/theme opacity (see plugins/custom.lua for transparency setup)
if vim.g.transparent_enabled == nil then
  vim.g.transparent_enabled = true
end

local function toggle_opacity()
  vim.g.transparent_enabled = not vim.g.transparent_enabled
  local scheme = vim.g.colors_name or "tokyonight"

  -- Reload the active theme's full config (from plugins/custom.lua),
  -- overriding only the transparency-related fields.
  if scheme:match("^catppuccin") then
    local opts = vim.deepcopy(LazyVim.opts("catppuccin"))
    opts.transparent_background = vim.g.transparent_enabled
    require("catppuccin").setup(opts)
  elseif scheme:match("^tokyonight") then
    local opts = vim.deepcopy(LazyVim.opts("tokyonight.nvim"))
    opts.transparent = vim.g.transparent_enabled
    opts.styles = opts.styles or {}
    opts.styles.sidebars = vim.g.transparent_enabled and "transparent" or "dark"
    opts.styles.floats = vim.g.transparent_enabled and "transparent" or "dark"
    require("tokyonight").setup(opts)
  end

  vim.cmd.colorscheme(scheme)
end

vim.keymap.set("n", "<leader>uo", toggle_opacity, { desc = "Toggle background opacity" })
