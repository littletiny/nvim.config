-- ============================================
-- LSP (Language Server Protocol) 配置
-- ============================================
-- 本文件配置 Neovim 的 LSP 客户端功能：
-- 1. 配置各语言的 LSP 服务器 (clangd, pyright, gopls, rust_analyzer)
-- 2. 设置 LSP 快捷键
-- 3. 配置 LSP 能力 (capabilities)
--
-- 前置要求: 需要手动安装 LSP 服务器
--   - clangd: C/C++ (apt install clangd 或 brew install llvm)
--   - pyright: Python (npm install -g pyright)
--   - gopls: Go (go install golang.org/x/tools/gopls@latest)
--   - rust_analyzer: Rust (rustup component add rust-analyzer)
-- ============================================

return {
    -- ============================================
    -- nvim-lspconfig: LSP 配置
    -- ============================================
    -- 提供各语言服务器的预设配置
    -- 网址: https://github.com/neovim/nvim-lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- cmp-nvim-lsp: 为 nvim-cmp 提供 LSP 补全能力
            -- 让代码补全引擎能够使用 LSP 的补全结果
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- 获取默认的 LSP 能力并增强以支持 nvim-cmp
            -- capabilities 告诉服务器客户端支持哪些功能
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- ============================================
            -- C/C++: clangd
            -- ============================================
            -- 功能: 代码补全、跳转定义、查找引用、重构等
            -- 安装: sudo apt install clangd 或 brew install llvm
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                filetypes = { "c", "cpp" },    -- 仅对 C/C++ 文件启用
            })
            vim.lsp.enable("clangd")

            -- ============================================
            -- Python: pyright
            -- ============================================
            -- 功能: 类型检查、代码补全、跳转定义
            -- 特点: 基于 Python 类型注解进行静态类型检查
            -- 安装: npm install -g pyright
            vim.lsp.config("pyright", {
                capabilities = capabilities,
            })
            vim.lsp.enable("pyright")

            -- ============================================
            -- Rust: rust_analyzer
            -- ============================================
            -- 功能: 代码补全、类型推断、跳转定义、重构
            -- 安装: rustup component add rust-analyzer
            vim.lsp.config("rust_analyzer", {})
            vim.lsp.enable("rust_analyzer")

            -- ============================================
            -- Go: gopls
            -- ============================================
            -- 功能: 代码补全、跳转定义、查找引用、重构、代码提示
            -- 安装: go install golang.org/x/tools/gopls@latest
            vim.lsp.config("gopls", {
                capabilities = capabilities,
                settings = {
                    gopls = {
                        -- 代码提示 (Hints) 配置
                        -- 在编辑器中显示额外的类型信息
                        hints = {
                            assignVariableTypes = false,      -- 不显示赋值变量类型
                            compositeLiteralFields = true,    -- 显示复合字面量字段
                            compositeLiteralTypes = true,     -- 显示复合字面量类型
                            constantValues = true,            -- 显示常量值
                            functionTypeParameters = true,    -- 显示函数类型参数
                            parameterNames = true,            -- 显示参数名
                            rangeVariableTypes = true,        -- 显示范围变量类型
                        },
                        semanticTokens = true,    -- 启用语义令牌 (更精确的语法高亮)
                    },
                },
            })
            vim.lsp.enable("gopls")

            -- ============================================
            -- LSP 快捷键映射
            -- ============================================
            -- 这些快捷键在 LSP 附加到缓冲区后生效
            -- 使用 <C-]> 等类似 Vim 传统 ctags 的键位

            -- <C-]>: 跳转到定义 (类似 ctags 的跳转)
            vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition,
                {noremap = true, silent = true, desc = 'goto symbol deinition [lsp]'})

            -- <C-k>: 显示函数签名帮助
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
                {noremap = true, silent = true, desc = 'show signture help [lsp]'})

            -- <C-M>: 显示悬停文档 (Hover)
            vim.keymap.set("n", "<C-M>", vim.lsp.buf.hover,
                {noremap = true, silent = true, desc = 'hover symbol comment [lsp]'})

            -- <C-d>: 跳转到实现
            vim.keymap.set("n", "<C-d>", vim.lsp.buf.implementation,
                {noremap = true, silent = true, desc = 'goto symbol implementation [lsp]'})

            -- <C-c>: 查看出向调用 (Outgoing Calls)
            -- 显示当前函数调用了哪些其他函数
            vim.keymap.set("n", "<C-c>", vim.lsp.buf.outgoing_calls,
                {noremap = true, silent = true, desc = 'function outgoing calls [lsp]'})

            -- <space>r: 查找引用
            -- 显示所有引用当前符号的位置
            vim.keymap.set("n", "<space>r", vim.lsp.buf.references,
                {noremap = true, silent = true, desc = 'symbol reference [lsp]'})

            -- <space>n: 重命名符号
            -- 安全地重命名变量、函数等，更新所有引用
            vim.keymap.set("n", "<space>n", vim.lsp.buf.rename,
                {noremap = true, silent = true, desc = 'symbol rename [lsp]'})

            -- 设置 LSP 日志级别
            -- 可选: "TRACE", "DEBUG", "INFO", "WARN", "ERROR"
            -- 日志文件位置: ~/.local/state/nvim/lsp.log
            vim.lsp.set_log_level("error")
        end,
    },
}
