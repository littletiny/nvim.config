-- ============================================
-- CodeCompanion + Fidget 状态指示器
-- 参考: https://github.com/olimorris/codecompanion.nvim/discussions/640
-- ============================================

return {
	-- Fidget.nvim - 用于显示 LSP/状态通知
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		config = function()
			local fidget = require("fidget")
			local progress = require("fidget.progress")
			local notification = require("fidget.notification")

			fidget.setup({
				progress = {
					suppress_on_insert = false,
					ignore_done_already = false,
					ignore_empty_message = false,
					clear_on_detach = function(client_id)
						local client = vim.lsp.get_client_by_id(client_id)
						return client and client.name or nil
					end,
					notification_group = function(msg)
						return msg.lsp_client.name
					end,
					ignore = {},
					display = {
						render_limit = 16,
						done_ttl = 3,
						done_icon = "✓",
						done_style = "Constant",
						progress_ttl = math.huge,
						progress_icon = { pattern = "dots", period = 1 },
						progress_style = "WarningMsg",
						group_style = "Title",
						icon_style = "Question",
						priority = 30,
						skip_history = true,
						format_message = require("fidget.progress.display").default_format_message,
						format_annote = function(msg)
							return msg.title
						end,
						format_group_name = function(group)
							return tostring(group)
						end,
						overrides = {
							rusty_ai = {
								name = "TrustyAI",
								icon = "🤖",
								update_hook = function(item, ctx)
									notification.set_content_key(item)
								end,
							},
						},
					},
				},
				notification = {
					poll_rate = 10,
					filter = vim.log.levels.INFO,
					history_size = 128,
					icons = {
						sent = "➜",
						pending = "⏳",
						done = "✓",
					},
					configs = {
						default = notification.default_config,
					},
					window = {
						normal_hl = "Comment",
						winblend = 0,
						border = "none",
						zindex = 45,
						max_width = 0,
						max_height = 0,
						x_padding = 1,
						y_padding = 0,
						align = "bottom",
						relative = "editor",
					},
				},
				integration = {
					["nvim-tree"] = {
						enable = false,
					},
				},
			})

			-- ============================================
			-- CodeCompanion Fidget 集成 + Chat 界面状态
			-- ============================================
			local handles = {}
			local chat_ns = vim.api.nvim_create_namespace("CodeCompanionChatStatus")
			local group = vim.api.nvim_create_augroup("CodeCompanionFidget", { clear = true })

			-- 在 chat 缓冲区显示状态图标
			local function show_chat_status(bufnr, status_icon, status_text)
				if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end
				-- 清除之前的状态
				vim.api.nvim_buf_clear_namespace(bufnr, chat_ns, 0, -1)
				-- 在最后一行添加状态虚拟文本
				local line_count = vim.api.nvim_buf_line_count(bufnr)
				vim.api.nvim_buf_set_extmark(bufnr, chat_ns, line_count - 1, 0, {
					virt_text = { { " " .. status_icon .. " " .. status_text, "Comment" } },
					virt_text_pos = "eol",
				})
			end

			-- 清除 chat 状态
			local function clear_chat_status(bufnr)
				if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
					vim.api.nvim_buf_clear_namespace(bufnr, chat_ns, 0, -1)
				end
			end

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequestStarted",
				group = group,
				callback = function(msg)
					-- Fidget 状态
					local handle = progress.handle.create({
						message = "Thinking...",
						lsp_client = { name = "CodeCompanion" },
					})
					handles[msg.data.id] = handle
					-- Chat 界面状态
					if msg.data and msg.data.bufnr then
						show_chat_status(msg.data.bufnr, "⏳", "sending...")
					end
				end,
			})

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequestStreaming",
				group = group,
				callback = function(msg)
					local handle = handles[msg.data.id]
					if handle then
						handle.message = "Generating..."
					end
					-- Chat 界面状态
					if msg.data and msg.data.bufnr then
						show_chat_status(msg.data.bufnr, "🤔", "generating...")
					end
				end,
			})

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequestFinished",
				group = group,
				callback = function(msg)
					local handle = handles[msg.data.id]
					if handle then
						handle:finish()
						handles[msg.data.id] = nil
					end
					-- 清除 Chat 界面状态
					if msg.data and msg.data.bufnr then
						clear_chat_status(msg.data.bufnr)
					end
				end,
			})

			-- ============================================
			-- CodeCompanion Header 整行高亮
			-- ============================================
			local header_ns = vim.api.nvim_create_namespace("CodeCompanionHeaderHighlight")

			-- 定义高亮组（根据 tokyonight 主题调整颜色）
			vim.api.nvim_set_hl(0, "CodeCompanionHeaderMe", {
				bg = "#3d59a1",  -- 蓝色背景（Me）
				fg = "#ffffff",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "CodeCompanionHeaderLLM", {
				bg = "#565f89",  -- 灰色背景（CodeCompanion）
				fg = "#ffffff",
				bold = true,
			})

			-- 刷新 header 高亮的函数
			local function refresh_header_highlights(bufnr)
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end
				local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
				if ft ~= "codecompanion" then
					return
				end

				-- 清除之前的高亮
				vim.api.nvim_buf_clear_namespace(bufnr, header_ns, 0, -1)

				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				for line_num, content in ipairs(lines) do
					-- 匹配 Me header (## Me)
					if content:match("^## Me$") or content:match("^## Me ") then
						vim.api.nvim_buf_set_extmark(bufnr, header_ns, line_num - 1, 0, {
							line_hl_group = "CodeCompanionHeaderMe",
							priority = 100,
						})
					-- 匹配 CodeCompanion header (## CodeCompanion ...)
					elseif content:match("^## CodeCompanion") then
						vim.api.nvim_buf_set_extmark(bufnr, header_ns, line_num - 1, 0, {
							line_hl_group = "CodeCompanionHeaderLLM",
							priority = 100,
						})
					end
				end
			end

			-- 监听 buffer 变化
			vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
				group = group,
				pattern = "*",
				callback = function(args)
					refresh_header_highlights(args.buf)
				end,
			})

			-- 专门监听 CodeCompanion 聊天打开事件
			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionChatOpened",
				group = group,
				callback = function(ev)
					if ev.data and ev.data.bufnr then
						vim.defer_fn(function()
							refresh_header_highlights(ev.data.bufnr)
						end, 100)
					end
				end,
			})
		end,
	},
}
