local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.showmode = false

vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true

vim.o.scrolloff = 10

vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.cursorlineopt = 'number'
vim.o.colorcolumn = '80'

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

require("lazy").setup({
	spec = {

		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

		{
			"nvim-treesitter/nvim-treesitter",
			branch = 'master',
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require'nvim-treesitter.configs'.setup {
					ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

					sync_install = false,

					auto_install = true,

					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
				}
			end
		},

		{
			'nvim-telescope/telescope.nvim', tag = '0.1.5',
			requires = { 'nvim-lua/plenary.nvim' }
		},

		{
			"lewis6991/gitsigns.nvim"
		},

		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				require('lualine').setup {
					options = {
						icons_enabled = true,
						theme = 'auto',
						component_separators = { left = '', right = ''},
						section_separators = { left = '', right = ''},
						disabled_filetypes = {
							statusline = {},
							winbar = {},
						},
						ignore_focus = {},
						always_divide_middle = true,
						always_show_tabline = true,
						globalstatus = false,
						refresh = {
							statusline = 1000,
							tabline = 1000,
							winbar = 1000,
							refresh_time = 16,
							events = {
								'WinEnter',
								'BufEnter',
								'BufWritePost',
								'SessionLoadPost',
								'FileChangedShellPost',
								'VimResized',
								'Filetype',
								'CursorMoved',
								'CursorMovedI',
								'ModeChanged',
							},
						}
					},
					sections = {
						lualine_a = {'mode'},
						lualine_b = {'branch', 'diff', 'diagnostics'},
						lualine_c = {'filename'},
						lualine_x = {'filetype', 'fileformat'},
						lualine_y = {'progress'},
						lualine_z = {'location'}
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {'filename'},
						lualine_x = {'location'},
						lualine_y = {},
						lualine_z = {}
					},
					tabline = {},
					winbar = {},
					inactive_winbar = {},
					extensions = {}
				}
			end
		},

		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {}
		},

		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {},
			dependencies = {
				"MunifTanjim/nui.nvim",
			}
		},

		{ 'ThePrimeagen/harpoon' },

		-- LSP Zone
		{'mason-org/mason.nvim', tag = 'v1.11.0', pin = true},
		{'mason-org/mason-lspconfig.nvim', tag = 'v1.32.0', pin = true},
		{'neovim/nvim-lspconfig', tag = 'v1.8.0', pin = true},
		{'hrsh7th/cmp-nvim-lsp'},
		{'hrsh7th/nvim-cmp'},

	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})

vim.cmd.colorscheme "catppuccin-mocha"

vim.keymap.set('n', '<leader>x', '<cmd>Explore<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist)

vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>lg', builtin.live_grep)

local ui = require('harpoon.ui')
vim.keymap.set('n', '<leader>a', function() require("harpoon.mark").add_file() end)
vim.keymap.set('n', '<leader>h', function() ui.toggle_quick_menu() end)
vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end)
vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end)
vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end)
vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end)

-- LSP Zone
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lspconfig_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup({})
require('mason-lspconfig').setup({
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
})

local cmp = require('cmp')

cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
	},
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
		['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),

		['<C-y>'] = cmp.mapping.confirm({select = false}),
	}),
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
})
