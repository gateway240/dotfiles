-- NOTE: This configuration is meant for Neovim v0.12 or greater

-- Learn about Neovim's lua api
-- https://neovim.io/doc/user/lua-guide.html

vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.signcolumn = "yes"
-- local project configs
vim.o.exrc = true
vim.o.secure = true

-- Spellcheck
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Space as the leader key
vim.g.mapleader = vim.keycode("<Space>")

-- Basic clipboard interaction
vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "x" }, "gp", '"+p', { desc = "Paste clipboard text" })

-- Command shortcuts
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>quitall<cr>", { desc = "Exit vim" })

vim.cmd.colorscheme("retrobox")

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/stevearc/conform.nvim.git", -- formatting
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		dockerfile = { "dockerfmt" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("mini.icons").setup({})
require("mini.snippets").setup({})
require("mini.completion").setup({})

require("mini.files").setup({
	options = {
		use_as_default_explorer = true,
	},
})
vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = "File explorer" })

require("mini.pick").setup({})
vim.keymap.set("n", "<leader><space>", "<cmd>Pick buffers<cr>", { desc = "Search open files" })
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Search all files" })
vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Search help tags" })

-- List of compatible language servers is here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.enable({ "gopls", "rust_analyzer" })
