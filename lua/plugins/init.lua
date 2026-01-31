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
				desc = "new codecompantionchat session",
			})
			vim.keymap.set({ "v" }, "<leader>a", ":CodeCompanionChat Add<CR>", {
				noremap = true,
				silent = true,
				desc = "add context to codecompantionchat",
			})
			vim.keymap.set({ "n", "v" }, "<leader>e", ":CodeCompanion ", {
				noremap = true,
				silent = false,
				desc = "执行codecompantion",
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
    "ntpeters/vim-better-whitespace",
    "johnfrankmorgan/whitespace.nvim",

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

    -- ============================================
    -- 彩虹括号
    -- ============================================
    -- "luochen1990/rainbow",
	"hiphish/rainbow-delimiters.nvim",

    -- ============================================
    -- C++ LSP 高亮
    -- ============================================
    -- "jackguo380/vim-lsp-cxx-highlight",

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
