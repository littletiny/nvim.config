-- ============================================
-- 补全配置 (nvim-cmp)
-- ============================================

return {
    -- 补全引擎
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- LSP 补全源
            "hrsh7th/cmp-nvim-lsp",
            -- Buffer 补全源
            "hrsh7th/cmp-buffer",
            -- 路径补全源
            "hrsh7th/cmp-path",
            -- 命令行补全源
            "hrsh7th/cmp-cmdline",
            -- LSP 签名帮助
            "hrsh7th/cmp-nvim-lsp-signature-help",
            -- Snippet 引擎
            "hrsh7th/vim-vsnip",
        },
        config = function()
            local cmp = require("cmp")
            
            -- 设置补全
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp_signature_help" },
                    { name = "nvim_lsp" },
                },
            })
        end,
    },
}
