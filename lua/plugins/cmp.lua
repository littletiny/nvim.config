-- ============================================
-- 代码补全配置 (nvim-cmp)
-- ============================================
-- 本文件配置 Neovim 的代码补全引擎：
-- 1. 配置 nvim-cmp 补全引擎
-- 2. 配置补全来源 (LSP, Buffer, Path 等)
-- 3. 设置补全快捷键
--
-- 主要组件:
-- - nvim-cmp: 补全引擎核心
-- - cmp-nvim-lsp: LSP 补全来源
-- - cmp-buffer: 缓冲区文本补全
-- - cmp-path: 文件路径补全
-- - cmp-cmdline: 命令行补全
-- - vim-vsnip: 代码片段引擎
-- ============================================

return {
    -- ============================================
    -- nvim-cmp: 补全引擎
    -- ============================================
    -- 现代化的 Neovim 补全引擎
    -- 网址: https://github.com/hrsh7th/nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- LSP 补全来源
            -- 从 LSP 服务器获取补全建议
            "hrsh7th/cmp-nvim-lsp",

            -- Buffer 补全来源
            -- 从当前缓冲区和其他缓冲区获取文本补全
            "hrsh7th/cmp-buffer",

            -- 路径补全来源
            -- 自动补全文件路径
            "hrsh7th/cmp-path",

            -- 命令行补全来源
            -- 在命令模式下提供补全
            "hrsh7th/cmp-cmdline",

            -- LSP 签名帮助
            -- 在输入函数参数时显示函数签名
            "hrsh7th/cmp-nvim-lsp-signature-help",

            -- Snippet 引擎
            -- 用于展开代码片段
            "hrsh7th/vim-vsnip",
        },
        config = function()
            local cmp = require("cmp")

            -- ============================================
            -- 补全引擎主配置
            -- ============================================
            cmp.setup({
                -- ----------------------------------------
                -- Snippet 配置
                -- ----------------------------------------
                snippet = {
                    expand = function(args)
                        -- 使用 vim-vsnip 展开代码片段
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },

                -- ----------------------------------------
                -- 快捷键映射
                -- ----------------------------------------
                -- 使用预设的插入模式映射并自定义
                mapping = cmp.mapping.preset.insert({
                    -- <C-d>: 向上滚动补全文档
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),

                    -- <C-f>: 向下滚动补全文档
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- <C-Space>: 手动触发补全
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- <CR>: 确认当前选中的补全项
                    -- ConfirmBehavior.Replace: 替换光标后的文本
                    -- select = true: 即使没有选择也确认第一项
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),

                    -- <Tab>: 选择下一个补全项
                    -- 如果补全菜单未显示，则执行默认的 Tab 行为
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),  -- 在插入和选择模式生效

                    -- <S-Tab>: 选择上一个补全项
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                -- ----------------------------------------
                -- 补全来源配置
                -- ----------------------------------------
                -- 优先级从上到下，先匹配的来源优先显示
                sources = {
                    -- 函数签名帮助 (最高优先级)
                    -- 在输入函数参数时显示签名提示
                    { name = "nvim_lsp_signature_help" },

                    -- LSP 补全
                    -- 来自语言服务器的智能补全
                    { name = "nvim_lsp" },

                    -- 注意: 以下来源当前未启用，可按需添加
                    -- { name = "buffer" },      -- 缓冲区文本
                    -- { name = "path" },        -- 文件路径
                    -- { name = "vsnip" },       -- 代码片段
                },

                -- ----------------------------------------
                -- 补全窗口外观 (可选配置)
                -- ----------------------------------------
                -- window = {
                --     completion = cmp.config.window.bordered(),
                --     documentation = cmp.config.window.bordered(),
                -- },

                -- ----------------------------------------
                -- 补全格式 (可选配置)
                -- ----------------------------------------
                -- formatting = {
                --     format = function(entry, vim_item)
                --         -- 添加来源标签
                --         vim_item.menu = ({
                --             nvim_lsp = "[LSP]",
                --             buffer = "[Buffer]",
                --             path = "[Path]",
                --         })[entry.source.name]
                --         return vim_item
                --     end,
                -- },
            })

            -- ============================================
            -- 命令行补全配置 (可选)
            -- ============================================
            -- 为 / 搜索和 : 命令行模式启用补全
            --
            -- cmp.setup.cmdline("/", {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = { { name = "buffer" } }
            -- })
            --
            -- cmp.setup.cmdline(":", {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = {
            --         { name = "path" },
            --         { name = "cmdline" }
            --     }
            -- })
        end,
    },
}
