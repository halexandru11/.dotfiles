-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer() -- true only if packer is not installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
	augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")

if not status then
	return
end

return packer.startup(function(use)
	-- packer can manage itself
	use 'wbthomason/packer.nvim'

  use "nvim-lua/plenary.nvim" -- lua functions that many plugins use

	-- for creating custom colorscheme
	use 'rktjmp/lush.nvim'

  -- github copilot
	use "github/copilot.vim"

  -- commenting with gc
	use "numToStr/Comment.nvim"

  -- color theme
  use "~/personal/tropical"
  use "folke/tokyonight.nvim"

  -- statusline
	use "nvim-lualine/lualine.nvim"

  -- harpoon
	use "ThePrimeagen/harpoon" -- quick navigation between files

  use "christoomey/vim-tmux-navigator" -- tmux & split window navigation

  use "tpope/vim-surround" -- add, delete, change surroundings (it's awesome)

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- the completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completion source for nvim-cmp
  use "hrsh7th/cmp-path" -- path completion source for nvim-cmp
  use "hrsh7th/cmp-cmdline" -- cmdline completion source for nvim-cmp
  use "saadparwaiz1/cmp_luasnip" -- snippets completion source for nvim-cmp
  use "hrsh7th/cmp-nvim-lsp" -- nvim-lsp completion source for nvim-cmp
  use "hrsh7th/cmp-nvim-lua" -- nvim-lua completion source for nvim-cmp

  -- snippets
  use "L3MON4D3/LuaSnip" -- snippet engine
  use "rafamadriz/friendly-snippets" -- snippets collection

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/mason.nvim" -- simple to use language server installer
  use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
  use 'jose-elias-alvarez/null-ls.nvim' -- LSP diagnostics and code actions

  -- Telescope
  use { "nvim-telescope/telescope.nvim", tag="0.1.0" }
  use "nvim-telescope/telescope-media-files.nvim"

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", tag="v0.7.2", run = ":TSUpdate" }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)
