-- ============================================
-- 基础插件配置
-- ============================================

return {
    -- ============================================
    -- 主题
    -- ============================================
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "storm",
                light_style = "day",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    sidebars = "dark",
                    floats = "transparent",
                },
                sidebars = { "qf", "help" },
                day_brightness = 0.3,
                hide_inactive_statusline = false,
                dim_inactive = false,
                lualine_bold = false,
                on_colors = function(colors) end,
                on_highlights = function(highlights, colors) end,
            })
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    -- ============================================
    -- AI / opencode 依赖
    -- ============================================
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            input = {
                enabled = true,
                icon = "> ",
            },
            picker = {
                enabled = true,
                sources = {
                    files = { cmd = "fdfind" },
                    grep = { cmd = "rg" },
                },
            },
            -- 禁用图像相关模块（避免非 kitty/wezterm 终端的警告）
            image = { enabled = false },
            -- 禁用需要额外依赖的模块
            terminal = { enabled = false },
            lazygit = { enabled = false },
            gitbrowse = { enabled = false },
            explorer = { enabled = false },
            dashboard = { enabled = false },
            notifier = { enabled = false },
            notify = { enabled = false },
            scratch = { enabled = false },
            scroll = { enabled = false },
            indent = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            scope = { enabled = false },
            win = { enabled = false },
            zen = { enabled = false },
            toggle = { enabled = false },
            quickfile = { enabled = false },
            rename = { enabled = false },
            git = { enabled = false },
            bufdelete = { enabled = false },
            debug = { enabled = false },
        },
    },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- 安装需要的 parser
			require("nvim-treesitter").install({
				"c", "lua", "vimdoc", "python", "javascript", "typescript", "rust", "yaml"
			})

			-- 启用 treesitter 高亮
			vim.api.nvim_create_autocmd('FileType', {
				pattern = { 'c', 'lua', 'vimdoc', 'python', 'javascript', 'typescript', 'rust', 'yaml' },
				callback = function() vim.treesitter.start() end,
			})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			--"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local codeagent = "codex"
			local user = "tiny"
			require("codecompanion").setup({
				opts = {
					log_level = "TRACE",
				},
				display = {
					chat = {
						show_token_count = true,
						start_in_insert_mode = false,
						show_tools_processing = true,
						show_settings = true,
						render_headers = true,
						show_reasoning = true,
						fold_reasoning = false,
						icons = {
							buffer_sync_all = "[S]",
							buffer_sync_diff = "[D]",
							chat_fold = "[-]",
							-- 工具调用状态图标
							tool_pending = "[?]",
							tool_in_progress = "[*]",
							tool_failure = "[X]",
							tool_success = "[OK]",
						},
					},
					opts = {
						send_code = true,
					},
				},
				interactions = {
					chat = {
						adapter = codeagent,
						roles = {
							user = "User (" .. user .. ")",
							llm = "AI assistant (" .. codeagent .. ")"
						},
					},
					inline = {
						adapter = "openai_compatible",
					},
					cmd = {
						adapter = "openai_compatible",
					},
				},
				adapters = {
					acp = {
						codex = function()
							return require("codecompanion.adapters").extend("codex", {
								env = {},
								handlers = {
									auth = function(_adapter)
										return true
									end,
								},
							})
						end,
					},
					http = {
						openai_compatible = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://ark.cn-beijing.volces.com",
									chat_url = "/api/v3/chat/completions",
									api_key = "VOLCENGINE_API_KEY",
								},
								headers = {
									["Content-Type"] = "application/json",
									["Authorization"] = "Bearer ${api_key}",
								},
								schema = {
									model = {
										default = "ep-20250825102943-4pws2",
									},
								},
								parameters = {
									sync = true,
								},
							})
						end,
					},
				},
			})

			vim.keymap.set({ "n" }, "<C-n>", ":CodeCompanionChat<CR>", {
				noremap = true,
				silent = true,
				desc = "new session [AI:agent]",
			})
			vim.keymap.set({ "v" }, "<leader>a", ":CodeCompanionChat Add<CR>", {
				noremap = true,
				silent = true,
				desc = "add visual content to current session as input [AI:agent]",
			})
			vim.keymap.set({ "n", "v" }, "<leader>e", ":CodeCompanion ", {
				noremap = true,
				silent = false,
				desc = "ask AI something, the response will insert to currnet file [AI:model]",
			})
		end,
	},

    -- ============================================
    -- LSP 诊断控制
    -- ============================================
    {
        "ColinKennedy/toggle-lsp-diagnostics.nvim",
        branch = "feature/disable_per_buffer",
        config = function()
            require("toggle_lsp_diagnostics").init({
                start_on = true,
                underline = true,
                virtual_text = false,
            })

            vim.diagnostic.config({
                virtual_text = false
            })

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    virtual_text = false,
                    signs = true,
                    update_in_insert = false,
                    underline = true,
                }
            )
        end,
    },

    -- ============================================
    -- 快速修复窗口增强
    -- ============================================
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
    },

    -- ============================================
    -- 空白字符处理
    -- ============================================
    --"ntpeters/vim-better-whitespace",
	{
		"johnfrankmorgan/whitespace.nvim",
		config = function()
			ws = require('whitespace-nvim')
			ws.setup({
				highlight = 'DiffDelete',
				ignored_filetypes = { 'TelescopePrompt', 'Trouble', 'help', 'dashboard' },
				ignore_terminal = true,
				return_cursor = true,
			})
			vim.keymap.set('n', '<Leader>t', ws.trim, {desc = 'trim all tail whitespace'})
		end,
	},

    -- ============================================
    -- 高亮单词
    -- ============================================
    "lfv89/vim-interestingwords",

    -- ============================================
    -- 文本对象增强
    -- ============================================
    "wellle/targets.vim",

    -- ============================================
    -- 文件搜索
    -- ============================================
    {
        "Yggdroot/LeaderF",
        build = "./install.sh",
    },

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			delay = 500,
			icons = {
				breadcrumb = "»", -- 分隔符
				separator = "➜", -- 符号与描述之间的连接符
				group = "+",      -- 文件夹/组的前缀
				mappings = false,
				enabled = false,
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
					operators = false,    -- 隐藏 d, y 等操作符
					motions = false,      -- 隐藏 h, j, k, l 等移动
					text_objects = false, -- 隐藏 i, a 等文本对象
					windows = false,      -- 隐藏 Ctrl-w 窗口指令
					nav = false,          -- 隐藏 Ctrl-d, Ctrl-u 等翻页指令
					z = false,            -- 隐藏 z 系列
					g = false,            -- 隐藏 g 系列
				},
			},
		},
		keys = {
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
	"hiphish/rainbow-delimiters.nvim",

    -- ============================================
    -- Git 集成
    -- ============================================
	{
		"airblade/vim-gitgutter",
		enabled = false,
	},
	"tpope/vim-fugitive",
	"junegunn/gv.vim",

    -- ============================================
    -- 状态栏
    -- ============================================
    "liuchengxu/eleline.vim",
}
