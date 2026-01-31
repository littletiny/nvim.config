-- ============================================
-- 基础插件配置
-- ============================================
-- 本文件包含核心插件配置，按功能分类：
-- 1. 主题与界面
-- 2. AI 相关 (snacks.nvim + codecompanion.nvim)
-- 3. LSP 诊断控制
-- 4. 编辑增强 (bqf, whitespace, targets.vim 等)
-- 5. 文件搜索 (LeaderF)
-- 6. Git 集成
-- 7. 其他工具 (which-key, rainbow-delimiters)
-- ============================================

return {
    -- ============================================
    -- 主题
    -- ============================================
    -- Tokyo Night: 深色主题，支持透明背景
    {
        "folke/tokyonight.nvim",
        lazy = false,        -- 立即加载，不延迟
        priority = 1000,     -- 高优先级，确保先加载
        config = function()
            require("tokyonight").setup({
                style = "storm",           -- 主题风格: storm/night/day/moon
                light_style = "day",       -- 浅色主题风格
                transparent = true,        -- 启用透明背景
                terminal_colors = true,    -- 设置终端颜色
                styles = {
                    comments = { italic = true },   -- 注释斜体
                    keywords = { italic = true },   -- 关键字斜体
                    functions = {},                 -- 函数无特殊样式
                    variables = {},                 -- 变量无特殊样式
                    sidebars = "dark",              -- 侧边栏深色
                    floats = "transparent",         -- 浮动窗口透明
                },
                sidebars = { "qf", "help" },        -- 指定为侧边栏的窗口类型
                day_brightness = 0.3,               -- 白天模式亮度
                hide_inactive_statusline = false,   -- 不隐藏非活动状态栏
                dim_inactive = false,               -- 不暗淡非活动窗口
                lualine_bold = false,               -- lualine 不使用粗体
                on_colors = function(colors) end,   -- 自定义颜色钩子
                on_highlights = function(highlights, colors) end,  -- 自定义高亮钩子
            })
            -- 应用主题
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    -- ============================================
    -- AI / 输入框依赖
    -- ============================================
    -- snacks.nvim: 提供现代化的 UI 组件
    -- 主要用于 codecompanion 的输入框
    {
        "folke/snacks.nvim",
        priority = 1000,     -- 高优先级加载
        lazy = false,        -- 立即加载
        ---@type snacks.Config
        opts = {
            -- 启用输入框模块
            input = {
                enabled = true,
                icon = "> ",    -- 输入框提示符
            },
            -- 启用文件选择器
            picker = {
                enabled = true,
                sources = {
                    files = { cmd = "fdfind" },   -- 使用 fdfind 搜索文件
                    grep = { cmd = "rg" },        -- 使用 rg 搜索内容
                },
            },
            -- 禁用以下模块（避免不必要的依赖或警告）
            image = { enabled = false },        -- 图像（需要 kitty/wezterm）
            terminal = { enabled = false },     -- 终端
            lazygit = { enabled = false },      -- lazygit 集成
            gitbrowse = { enabled = false },    -- git 浏览器
            explorer = { enabled = false },     -- 文件浏览器
            dashboard = { enabled = false },    -- 启动页
            notifier = { enabled = false },     -- 通知
            notify = { enabled = false },       -- 通知（旧）
            scratch = { enabled = false },      -- 草稿
            scroll = { enabled = false },       -- 滚动动画
            indent = { enabled = false },       -- 缩进线
            statuscolumn = { enabled = false }, -- 状态列
            words = { enabled = false },        -- 单词高亮
            scope = { enabled = false },        -- 范围高亮
            win = { enabled = false },          -- 窗口管理
            zen = { enabled = false },          -- 禅模式
            toggle = { enabled = false },       -- 切换开关
            quickfile = { enabled = false },    -- 快速文件
            rename = { enabled = false },       -- 重命名
            git = { enabled = false },          -- git 状态
            bufdelete = { enabled = false },    -- 缓冲区删除
            debug = { enabled = false },        -- 调试
        },
    },

    -- ============================================
    -- 语法高亮
    -- ============================================
    -- nvim-treesitter: 基于 Tree-sitter 的现代语法高亮
    -- 比传统正则高亮更准确、性能更好
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,           -- 立即加载
        build = ":TSUpdate",    -- 安装后自动更新 parser
        config = function()
            -- 安装需要的 parser
            require("nvim-treesitter").install({
                "c",           -- C 语言
                "lua",         -- Lua (本配置使用)
                "vimdoc",      -- Vim 文档
                "python",      -- Python
                "javascript",  -- JavaScript
                "typescript",  -- TypeScript
                "rust",        -- Rust
                "yaml",        -- YAML
            })

            -- 启用 treesitter 高亮
            -- 为指定文件类型启用 Tree-sitter 语法高亮
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'c', 'lua', 'vimdoc', 'python', 'javascript', 'typescript', 'rust', 'yaml' },
                callback = function() vim.treesitter.start() end,
            })
        end,
    },

    -- ============================================
    -- AI 助手: CodeCompanion
    -- ============================================
    -- 提供 AI 聊天和代码补全功能
    -- 支持 HTTP 适配器 (OpenAI 兼容) 和 ACP 适配器 (本地 CLI 工具)
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",    -- Lua 工具库
        },
        config = function()
            local codeagent = "codex"    -- 默认使用 codex 适配器
            local user = "tiny"          -- 用户名显示

            require("codecompanion").setup({
                -- 日志级别: TRACE/DEBUG/INFO/WARN/ERROR
                opts = {
                    log_level = "TRACE",
                },

                -- 显示配置
                display = {
                    chat = {
                        show_token_count = true,         -- 显示 Token 数量
                        start_in_insert_mode = false,    -- 不在插入模式启动
                        show_tools_processing = true,    -- 显示工具处理状态
                        show_settings = true,            -- 显示设置
                        render_headers = true,           -- 渲染消息头
                        show_reasoning = true,           -- 显示推理过程
                        fold_reasoning = false,          -- 不折叠推理
                        icons = {
                            buffer_sync_all = "[S]",     -- 缓冲区同步图标
                            buffer_sync_diff = "[D]",    -- Diff 同步图标
                            chat_fold = "[-]",           -- 折叠图标
                            -- 工具调用状态图标
                            tool_pending = "[?]",
                            tool_in_progress = "[*]",
                            tool_failure = "[X]",
                            tool_success = "[OK]",
                        },
                    },
                    opts = {
                        send_code = true,   -- 允许发送代码到 AI
                    },
                },

                -- 交互模式配置
                interactions = {
                    -- 聊天模式
                    chat = {
                        adapter = codeagent,
                        roles = {
                            user = "User (" .. user .. ")",
                            llm = "AI assistant (" .. codeagent .. ")"
                        },
                    },
                    -- 内联模式
                    inline = {
                        adapter = "openai_compatible",
                    },
                    -- 命令模式
                    cmd = {
                        adapter = "openai_compatible",
                    },
                },

                -- 适配器配置
                adapters = {
                    -- ACP (Agent Communication Protocol) 适配器
                    -- 用于本地 CLI 工具如 codex
                    acp = {
                        codex = function()
                            return require("codecompanion.adapters").extend("codex", {
                                env = {},
                                handlers = {
                                    auth = function(_adapter)
                                        return true  -- 自动认证
                                    end,
                                },
                            })
                        end,
                    },
                    -- HTTP 适配器
                    -- 用于 OpenAI 兼容的 API 服务
                    http = {
                        openai_compatible = function()
                            return require("codecompanion.adapters").extend("openai_compatible", {
                                env = {
                                    url = "https://ark.cn-beijing.volces.com",           -- API 基础 URL
                                    chat_url = "/api/v3/chat/completions",              -- 聊天端点
                                    api_key = "VOLCENGINE_API_KEY",                      -- API 密钥环境变量名
                                },
                                headers = {
                                    ["Content-Type"] = "application/json",
                                    ["Authorization"] = "Bearer ${api_key}",
                                },
                                schema = {
                                    model = {
                                        default = "ep-20250825102943-4pws2",  -- 默认模型
                                    },
                                },
                                parameters = {
                                    sync = true,   -- 同步请求
                                },
                            })
                        end,
                    },
                },
            })

            -- ============================================
            -- CodeCompanion 快捷键映射
            -- ============================================

            -- <C-n>: 新建 CodeCompanion 聊天会话
            vim.keymap.set({ "n" }, "<C-n>", ":CodeCompanionChat<CR>", {
                noremap = true,
                silent = true,
                desc = "new session [AI:agent]",
            })

            -- <leader>a (Visual): 将选中内容添加到当前会话
            vim.keymap.set({ "v" }, "<leader>a", ":CodeCompanionChat Add<CR>", {
                noremap = true,
                silent = true,
                desc = "add visual content to current session as input [AI:agent]",
            })

            -- <leader>e: 执行 CodeCompanion 命令（直接修改当前文件）
            vim.keymap.set({ "n", "v" }, "<leader>e", ":CodeCompanion ", {
                noremap = true,
                silent = false,
                desc = "ask AI something, the response will insert to currnet file [AI:model]",
            })

            -- <leader>t: 执行 CodeCompanionChat Toggle 命令（显示/隐藏 AI面板）
            vim.keymap.set({ "n", "v" }, "<leader>t", ":CodeCompanionChat Toggle<CR>", {
                noremap = true,
                silent = true,
                desc = "show/hide current chat buffer [AI:agent]"
            })
        end,
    },

    -- ============================================
    -- LSP 诊断控制
    -- ============================================
    -- toggle-lsp-diagnostics: 控制 LSP 诊断的显示
    {
        "ColinKennedy/toggle-lsp-diagnostics.nvim",
        branch = "feature/disable_per_buffer",  -- 使用支持每缓冲区禁用的分支
        config = function()
            require("toggle_lsp_diagnostics").init({
                start_on = true,     -- 启动时启用诊断
                underline = true,    -- 下划线标记问题
                virtual_text = false, -- 不显示虚拟文本（减少干扰）
            })

            -- 诊断显示配置
            vim.diagnostic.config({
                virtual_text = false
            })

            -- 发布诊断时的处理
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    virtual_text = false,      -- 不显示虚拟文本
                    signs = true,              -- 显示符号标记
                    update_in_insert = false,  -- 插入模式不更新
                    underline = true,          -- 下划线标记
                }
            )
        end,
    },

    -- ============================================
    -- 快速修复窗口增强
    -- ============================================
    -- nvim-bqf: 增强 quickfix 窗口功能
    -- 提供更好的预览、过滤和导航
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",    -- 仅在 quickfix 文件类型时加载
    },

    -- ============================================
    -- 空白字符处理
    -- ============================================
    -- whitespace.nvim: 自动检测并删除行尾空白
    {
        "johnfrankmorgan/whitespace.nvim",
        config = function()
            local ws = require('whitespace-nvim')
            ws.setup({
                highlight = 'DiffDelete',     -- 使用 DiffDelete 高亮
                -- 忽略的文件类型
                ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
                ignore_terminal = true,       -- 忽略终端缓冲区
                return_cursor = true,         -- 操作后恢复光标位置
            })
            -- <leader>t: 修剪所有行尾空白
            vim.keymap.set('n', '<Leader>t', ws.trim, {desc = 'trim all tail whitespace'})
        end,
    },

    -- ============================================
    -- 高亮单词
    -- ============================================
    -- vim-interestingwords: 高亮光标下的单词
    -- 方便快速查看变量在文件中的所有出现位置
    "lfv89/vim-interestingwords",

    -- ============================================
    -- 文本对象增强
    -- ============================================
    -- targets.vim: 提供更多文本对象
    -- 例如: cin) 修改括号内内容，包括嵌套情况
    "wellle/targets.vim",

    -- ============================================
    -- 文件搜索
    -- ============================================
    -- LeaderF: 模糊搜索神器
    -- 支持文件、函数、行、rg 搜索等
    {
        "Yggdroot/LeaderF",
        build = "./install.sh",    -- 安装时编译
    },

    -- ============================================
    -- 快捷键提示
    -- ============================================
    -- which-key.nvim: 显示可用的快捷键
    -- 按 <leader> 后会弹出提示窗口
    {
        "folke/which-key.nvim",
        event = "VeryLazy",    -- 延迟加载
        opts = {
            delay = 500,       -- 显示延迟 (毫秒)
            icons = {
                breadcrumb = "»",    -- 分隔符
                separator = "➜",     -- 符号与描述之间的连接符
                group = "+",         -- 文件夹/组的前缀
                mappings = false,    -- 不显示映射图标
                enabled = false,     -- 禁用图标
                -- 使用纯文本替代 Nerd Font 图标，避免显示问题
                keys = {
                    Up = "Up ",
                    Down = "Down ",
                    Left = "Left ",
                    Right = "Right ",
                    C = "Ctrl-",
                    M = "Alt-",
                    D = "Cmd-",
                    S = "Shift-",
                    CR = "Enter",
                    Esc = "Esc",
                    ScrollWheelDown = "ScrollDown ",
                    ScrollWheelUp = "ScrollUp ",
                    NL = "Enter ",
                    BS = "Backspace",
                    Space = "Space",
                    Tab = "Tab",
                    F1 = "F1",
                    F2 = "F2",
                    F3 = "F3",
                    F4 = "F4",
                    F5 = "F5",
                    F6 = "F6",
                    F7 = "F7",
                    F8 = "F8",
                    F9 = "F9",
                    F10 = "F10",
                    F11 = "F11",
                    F12 = "F12",
                },
            },
            plugins = {
                presets = {
                    operators = false,    -- 隐藏 d, y 等操作符提示
                    motions = false,      -- 隐藏 h, j, k, l 等移动提示
                    text_objects = false, -- 隐藏 i, a 等文本对象提示
                    windows = false,      -- 隐藏 Ctrl-w 窗口指令提示
                    nav = false,          -- 隐藏 Ctrl-d, Ctrl-u 等翻页提示
                    z = false,            -- 隐藏 z 系列提示
                    g = false,            -- 隐藏 g 系列提示
                },
            },
        },
        keys = {
            -- <leader>?: 显示缓冲区本地快捷键
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = true })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- ============================================
    -- 彩虹括号
    -- ============================================
    -- rainbow-delimiters.nvim: 用不同颜色显示嵌套括号
    -- 方便识别括号匹配
    "hiphish/rainbow-delimiters.nvim",

    -- ============================================
    -- Git 集成
    -- ============================================
    -- vim-fugitive: Git 命令包装器
    -- 提供 :Git 命令和 git 对象支持
    "tpope/vim-fugitive",

    -- gv.vim: Git 提交日志浏览器
    -- 可视化查看提交历史
    "junegunn/gv.vim",

    -- ============================================
    -- 状态栏
    -- ============================================
    -- eleline.vim: 轻量级状态栏
    -- 显示文件信息、Git 状态、LSP 状态等
    "liuchengxu/eleline.vim",
}
