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
