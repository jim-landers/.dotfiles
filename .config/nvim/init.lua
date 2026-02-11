vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.showtabline = 4

vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.g.mapleader = " "

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch" })
	end,
})

-- Normal Mode Binds
vim.keymap.set("n", "<leader>so", ":update<CR> :source<CR>", { desc = "[S]hout [O]ut" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
--
local lazygit_toggle = function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.fn.jobstart("lazygit", {
		term = true,
		on_exit = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})
	vim.cmd("startinsert")
end
vim.keymap.set("n", "<leader>gg", lazygit_toggle, { desc = "LazyGit" })

-- Terminal Mode Binds
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Visual Mode Binds
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Plugin setup and binds
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
})

vim.cmd("colorscheme vague")
-- Tmux in Windows Terminal does not work with colors well unless this is set.
-- Need more info on how this plays in other terminal applications
vim.cmd("set termguicolors")

-- Janky way of fixing cursor flying all over the place in insert mode
-- when combined with how autosuggestions are configured.
-- Should figure out how to better fix eventually
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		require("smear_cursor").enabled = false
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		require("smear_cursor").enabled = true
	end,
})

local mylsps = {
	-- Go
	"gopls",
	-- Lua
	"lua_ls",
	"stylua",
	-- Python
	"basedpyright",
	-- TypeScript
	"vtsls",
}

require("mason").setup()
-- mason-lspconfig isn't very necessary, but convenient for auto enabling lsps installed
-- on the fly (I think?)
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = mylsps,
})

vim.lsp.enable(mylsps)

-- Autosuggestions
vim.o.complete = ".,o" -- use buffer and omnifunc
vim.o.completeopt = "fuzzy,menuone,noselect" -- add 'popup' for docs (sometimes)
vim.o.pumheight = 4
vim.o.autocomplete = true
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
			-- Optional formating of items
			convert = function(item)
				-- Remove leading misc chars for abbr name,
				-- and cap field to 25 chars
				--local abbr = item.label
				--abbr = abbr:match("[%w_.]+.*") or abbr
				--abbr = #abbr > 25 and abbr:sub(1, 24) .. "…" or abbr
				--
				-- Remove return value
				--local menu = ""

				-- Only show abbr name, remove leading misc chars (bullets etc.),
				-- and cap field to 15 chars
				local abbr = item.label
				abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
				abbr = abbr:match("[%w_.]+.*") or abbr
				abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

				-- Cap return value field to 15 chars
				local menu = item.detail or ""
				menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

				return { abbr = abbr, menu = menu }
			end,
		})
	end,
})

-- All this does is fix vim config lua errors/warnings
-- See: https://github.com/neovim/neovim/issues/21686
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "require" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "[L]anguage [F]ormat" })

require("mini.pairs").setup()
require("mini.pick").setup({})
vim.keymap.set("n", "<leader>sh", ":Pick help<CR>", { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sf", ":Pick files<CR>", { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", ":Pick grep_live<CR>", { desc = "[S]earch [G]rep" })
vim.keymap.set("n", "<leader>sb", ":Pick buffers<CR>", { desc = "[S]earch [B]uffers" })

local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		-- Leader triggers
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },

		-- `[` and `]` keys
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },

		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- `g` key
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },

		-- Marks
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },

		-- Registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },

		-- Window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
})

require("flash").setup()
-- These binds are pretty much default (from flash setup)
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })

local gs = require("gitsigns")
gs.setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
	current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	-- Keymaps set below here
})

gs.setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true }, { desc = "Git Hunk Next" })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true }, { desc = "Git Hunk Prev." })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git [H]unk [S]tage" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git [H]unk [R]eset" })

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Git [H]unk [S]tage" })

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Git [H]unk [R]eset" })

		map("n", "<leadef>hS", gitsigns.stage_buffer, { desc = "Git [H]unk [S]tage Buffer" })
		map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git [H]unk [R]eset Buffer" })
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git [H]unk [P]review" })
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Git [H]unk Preview [I]nline" })

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Git Blame" })

		map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git Diff" })

		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, { desc = "Git Diff (Prev. Commit)" })

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end, { desc = "Git Set QF List (All)" })
		map("n", "<leader>hq", gitsigns.setqflist, { desc = "Git Set QF List (Buffer)" })

		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Git [T]oggle Line [B]lame" })
		map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Git [T]oggle Word [D]iff" })

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Git [I]nside [H]unk" })
	end,
})

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "<leader>-", ":Oil<CR>", { desc = "Open parent[-] directory" })
