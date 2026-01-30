-- ============================================
-- Neovim Configuration with lazy.nvim
-- 从 vim-plug 迁移到 lazy.nvim
-- ============================================

-- 设置 leader 键 (必须在加载 lazy.nvim 之前设置)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- 加载基础配置
require("config.options")

-- 加载 lazy.nvim 和插件
require("config.lazy")
