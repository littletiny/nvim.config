-- ============================================
-- LSP 配置
-- ============================================

return {
    -- LSP 配置
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- 补全能力
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            
            -- 配置各个 LSP 服务器 (使用新的 vim.lsp.config API)
            -- clangd 配置
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                filetypes = { "c", "cpp" },
            })
            vim.lsp.enable("clangd")
            
            -- pyright 配置
            vim.lsp.config("pyright", {
                capabilities = capabilities,
            })
            vim.lsp.enable("pyright")


			vim.lsp.config("rust_analyzer", {}) 
			vim.lsp.enable("rust_analyzer")
            
            -- gopls 配置
            vim.lsp.config("gopls", {
                capabilities = capabilities,
                settings = {
                    gopls = {
                        hints = {
                            assignVariableTypes = false,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        semanticTokens = true,
                    },
                },
            })
            vim.lsp.enable("gopls")
            
            -- LSP 键位映射
            local bufopts = { noremap = true, silent = true }
            vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "<C-M>", vim.lsp.buf.hover, bufopts)
            vim.keymap.set("n", "<C-d>", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<C-c>", vim.lsp.buf.outgoing_calls, bufopts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "<space>r", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "<space>n", vim.lsp.buf.rename, bufopts)
            
            -- 设置日志级别
            vim.lsp.set_log_level("error")
        end,
    },
}
