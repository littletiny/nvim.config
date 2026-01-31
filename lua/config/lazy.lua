-- ============================================
-- lazy.nvim Bootstrap and Setup
-- ============================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        lazyrepo, lazypath
    })
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

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- 导入所有插件配置
        { import = "plugins" },
    },
    -- 安装时使用的配色方案
    install = { colorscheme = { "tokyonight" } },
    -- 自动检查更新（静默模式，不提示 Press Enter）
    checker = { enabled = true, notify = false },
    -- 禁用 luarocks (如果不需要)
    rocks = { enabled = false },
    -- 禁用配置变更自动重载
    change_detection = { enabled = false },
    -- 性能优化
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
