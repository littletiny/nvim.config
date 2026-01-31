-- ============================================
-- 基础 Vim 配置
-- 从 init.vim.bak 迁移
-- ============================================
-- 本文件包含:
-- 1. 基础 Vim 选项设置 (缩进、搜索、界面等)
-- 2. 自动命令 (文件类型检测、自动保存等)
-- 3. 键位映射 (LeaderF、Git、LSP 等)
-- 4. 全局变量设置 (LeaderF、GTAGS 等)
-- 5. AI 输入框相关函数
-- ============================================

local opt = vim.opt
local g = vim.g

-- ============================================
-- Python 配置
-- ============================================
-- 指定 Python3 解释器路径，用于 Neovim 的 Python 接口
vim.g.python3_host_prog = "/usr/bin/python3"

-- ============================================
-- 鼠标与剪贴板配置
-- ============================================

-- 启用鼠标支持（仅 normal/visual 模式，方便终端复制）
-- 'nv' = normal + visual 模式，不在 insert 模式启用避免干扰
vim.o.mouse = 'nv'

-- 跳转选项: "stack" 使用标签栈方式管理跳转历史
-- 使得 <C-o> <C-i> 可以在跳转历史中来回导航
vim.opt.jumpoptions = "stack"

-- 剪贴板配置
-- unnamedplus: 使用系统剪贴板 (+ 寄存器)
-- unnamed: 使用主选择缓冲区 (* 寄存器)
opt.clipboard:append("unnamedplus")
opt.clipboard:append("unnamed")

-- 通过 OSC52 协议实现远程/终端内的剪贴板同步
-- 当文本被复制(yank)时，自动同步到系统剪贴板
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
    copy_to_unnamedplus(vim.v.event.regcontents)
    local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
    copy_to_unnamed(vim.v.event.regcontents)
  end,
})

-- ============================================
-- 补全与编码配置
-- ============================================

-- 补全选项:
-- menu: 显示补全菜单
-- menuone: 即使只有一个匹配也显示菜单
-- noselect: 不自动选择第一个匹配项
-- preview: 在预览窗口显示文档
opt.completeopt = { "menu", "menuone", "noselect", "preview" }

-- 文件编码检测顺序: UTF-8 -> UCS-BOM -> GB18030 -> GBK -> GB2312 -> CP936
-- 确保中文文件能正确显示
opt.fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936"

-- 设置环境变量和默认编码
vim.env.LANG = "en_US.UTF-8"
opt.encoding = "utf-8"

-- ============================================
-- 界面显示配置
-- ============================================

-- 显示行号
opt.number = true

-- 显示相对行号 (当前行为 0，上下行显示相对距离)
-- 方便使用 [count]j/k 进行跳转
opt.relativenumber = true

-- 不显示当前行高亮
opt.cursorline = false

-- 启用语法高亮 (使用 vim.cmd 确保生效)
vim.cmd("syntax on")

-- 始终显示状态栏
opt.laststatus = 2

-- 垂直分割时新窗口在右侧
opt.splitright = true

-- 允许隐藏未保存的缓冲区
-- 可以在不保存的情况下切换缓冲区
opt.hidden = true

-- ============================================
-- 缩进与制表符配置
-- ============================================

-- Tab 显示宽度为 4 个空格
opt.tabstop = 4

-- 自动缩进宽度为 4 个空格
opt.shiftwidth = 4

-- 按 Tab 键时插入 4 个空格宽度的字符
opt.softtabstop = 4

-- 缩进时对齐到 shiftwidth 的倍数
opt.shiftround = true

-- 不将 Tab 转换为空格 (使用真实 Tab 字符)
-- 适用于 Makefile 等需要真实 Tab 的文件
opt.expandtab = false

-- 启用 C 风格自动缩进
opt.cindent = true

-- 智能缩进 (根据上下文自动调整)
opt.smartindent = true

-- 自动继承上一行的缩进
opt.autoindent = true

-- ============================================
-- 搜索配置
-- ============================================

-- 高亮搜索结果
opt.hlsearch = true

-- 搜索时忽略大小写
opt.ignorecase = true

-- 智能大小写: 如果搜索包含大写字母，则区分大小写
opt.smartcase = true

-- ============================================
-- 其他常用选项
-- ============================================

-- 不创建备份文件
opt.backup = false

-- 退格键可以删除: 缩进、行尾、插入起始点
opt.backspace = { "indent", "eol", "start" }

-- Tags 文件搜索路径
-- ./.tags; 表示从当前目录向上递归查找 .tags 文件
opt.tags = "./.tags;"

-- 鼠标模式与扩展 (与 mouse='nv' 配合)
opt.mouse = "nv"
opt.mousemodel = "extend"

-- 文件被外部修改时自动重新加载
opt.autoread = true

-- 在右下角显示部分输入的命令
opt.showcmd = true

-- 不禁用延迟重绘，确保命令行立即显示
opt.lazyredraw = false

-- 命令行高度
opt.cmdheight = 1

-- ============================================
-- 自动命令 (Autocommands)
-- ============================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 自动跳转到上次编辑位置
-- 打开文件时，光标恢复到上次关闭时的位置
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line = mark[1]
        if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Makefile 使用真实 Tab (不展开为空格)
autocmd("FileType", {
    pattern = "make",
    command = "setlocal noexpandtab",
})

-- 补全完成后自动关闭预览窗口
autocmd("CompleteDone", {
    pattern = "*",
    command = "if pumvisible() == 0 | pclose | endif",
})

-- 禁用 .h 文件的 LSP 诊断
-- 避免 C 头文件被错误地识别为 C++ 产生误报
autocmd({"BufEnter", "BufWinEnter", "BufRead", "BufReadPre", "FileReadPre"}, {
    pattern = ".h",
    callback = function(args)
        vim.diagnostic.enable(false, { bufnr = args.buf })
    end,
})

-- 设置特定文件扩展名的文件类型
-- .ic 和 .i.*.CU 文件识别为 C++
autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.ic", "*.i.*.CU"},
    command = "set filetype=cpp",
})

-- ============================================
-- 键位映射
-- ============================================
-- 注意: 以下映射主要使用 <leader> (空格) 和 <localleader> (,) 作为前缀
-- which-key 插件会在按下 <leader> 后显示可用的快捷键提示

local map = vim.keymap.set

-- --------------------------------------------
-- LeaderF 文件搜索键位
-- --------------------------------------------
-- LeaderF 是一个模糊搜索插件，用于快速定位文件、函数、行等

-- <C-e>: 搜索当前文件中的函数/符号
map("n", "<C-e>", [[:<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>]], 
    { silent = true, desc = 'search & list functions in current file' })

-- <C-p>: 模糊搜索文件
map("n", "<C-p>", ":LeaderfFile<CR>", 
    { silent = true, desc = 'search & list file in current dir' })

-- <C-l>: 搜索当前文件的行
map("n", "<C-l>", [[:<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>]], 
    { silent = true, desc = 'search & list line in current file' })

-- <leader>w: 搜索光标下的单词 (使用 rg)
map("n", "<leader>w", [[:<C-U><C-R>=printf("Leaderf! rg %s", expand("<cword>"))<CR><CR>]], 
    { silent = false, desc = 'grep current word' })

-- <leader>g: 搜索输入的内容 (使用 rg)
map("n", "<leader>g", [[:<C-U><C-R>=printf("Leaderf rg %s", "")<CR>]], 
    { silent = false, desc = 'grep input word' })

-- <leader>f: 搜索所有 LeaderF 命令
map("n", "<leader>f", [[:<C-U><C-R>=printf("Leaderf self %s --all-commands", "")<CR><CR>]], 
    { silent = true, desc = 'search & list all commands' })

-- --------------------------------------------
-- Git 相关键位
-- --------------------------------------------

-- <localleader>g ( ,g ): 打开 GV - Git 提交日志浏览器
map("n", "<localleader>g", ":GV<CR>", 
    { silent = true, desc = 'git log --oneline current repo' })

-- <leader>b: 打开 Git blame
map("n", "<leader>b", ":Git blame<CR>", 
    { silent = true, desc = 'git blame current file' })

-- --------------------------------------------
-- LSP 诊断键位
-- --------------------------------------------

-- <leader>d: 显示当前行的诊断信息
map("n", "<leader>d", function() vim.diagnostic.open_float() end, 
    { silent = true, desc = 'show diagnose in current line [lsp]' })

-- ============================================
-- 全局变量设置
-- ============================================

-- --------------------------------------------
-- LeaderF 插件设置
-- --------------------------------------------
-- 详细配置参考: https://github.com/Yggdroot/LeaderF

g.Lf_ShowDevIcons = 0              -- 不显示文件类型图标

g.Lf_PreviewInPopup = 1            -- 在弹出窗口中预览

g.Lf_WindowPosition = "popup"      -- 使用弹出窗口显示结果

g.Lf_GtagsAutoGenerate = 0         -- 不自动生成 GTAGS

g.Lf_CacheDirectory = vim.fn.expand("~/.cache/")  -- 缓存目录

g.Lf_UseVersionControlTool = 0     -- 不使用版本控制工具

g.Lf_WindowHeight = 0.3            -- 窗口高度 (30%)

g.Lf_PopupWidth = 0.75             -- 弹出窗口宽度 (75%)

-- 忽略的文件和目录
-- 在文件搜索时排除这些项目
-- dir: 忽略的目录
-- file: 忽略的文件类型
g.Lf_WildIgnore = {
    dir = { ".git", "deps" },
    file = { "*.sw?", "*.o", "*.so.*", "*.so", "*.py[co]" }
}

g.Lf_DefaultMode = "FullPath"      -- 默认使用全路径匹配模式

-- MRU (最近使用文件) 排除列表
g.Lf_MruFileExclude = { "*.sw?", "*.o", "*.so.*", "*.so", "*.py[co]" }

-- 弹出窗口位置: { 行偏移, 列偏移 }
g.Lf_PopupPosition = { 1, 0 }

-- 预览窗口位置: 底部
g.Lf_PopupPreviewPosition = "bottom"

-- --------------------------------------------
-- GTAGS (GNU Global) 设置
-- --------------------------------------------
-- 用于代码跳转和符号搜索

vim.env.GTAGSLABEL = "native-pygments"  -- 使用 native-pygments 解析器
vim.env.GTATGSCONF = "/usr/share/global/gtags/gtags.conf"

-- --------------------------------------------
-- opencode 设置 (备用 AI 工具)
-- --------------------------------------------
g.opencode_opts = {}

-- --------------------------------------------
-- Tagbar Go 语言配置
-- --------------------------------------------
-- 定义 Go 语言的 ctags 解析规则

g.tagbar_type_go = {
    ctagstype = "go",
    kinds = {
        "p:package",
        "i:imports:1",
        "c:constants",
        "v:variables",
        "t:types",
        "n:interfaces",
        "w:fields",
        "e:embedded",
        "m:methods",
        "r:constructor",
        "f:functions"
    },
    sro = ".",
    kind2scope = {
        t = "ctype",
        n = "ntype"
    },
    scope2kind = {
        ctype = "t",
        ntype = "n"
    },
    ctagsbin = "gotags",
    ctagsargs = "-sort -silent"
}

-- ============================================
-- AI 输入框函数
-- ============================================
-- 该函数创建一个独立的输入框，用于向 CodeCompanion AI 发送消息
-- 复用 CodeCompanionChat 的 Toggle 机制，而不是重新实现

local function snacks_ai_independent_input()
  local snacks = require("snacks")
  local cc = require("codecompanion")

  -- 检查并确保 chat buffer 是打开状态
  local chat = cc.last_chat()
  if not chat or not chat.ui:is_visible() then
    -- 如果 chat 不存在或不可见，打开它
    cc.toggle()
    -- 重新获取 chat（toggle 后可能创建了新的）
    chat = cc.last_chat()
  end

  local actual_width = 0.5
  actual_width = math.floor(vim.o.columns * actual_width)

  -- 创建输入框
  snacks.input({
    prompt = "User message: ",
    win = {
      relative = "editor",
      position = "float",
      -- 计算位置：紧贴右侧
      col = vim.o.columns - actual_width + 2,
      row = vim.o.lines - 3, -- 距离底部 3 行，避开状态栏
      width = actual_width - 1,
      border = "rounded",
      title_pos = "center",
      -- 设置特定样式确保它在最上层
      style = "input",
      icon = "",
      zindex = 100,
    },
  }, function(input)
    if not input or input == "" then return end

    -- 核心逻辑：注入文字并提交
    local function process_input(target_chat)
      target_chat:add_buf_message({ role = "user", content = input })
      vim.schedule(function()
        target_chat:submit()
      end)
    end

    -- 重新获取最新的 chat 实例
    local target_chat = cc.last_chat()
    if target_chat then
      process_input(target_chat)
    end

  end)
end

-- 绑定 <leader>c 到 AI 输入框
-- Normal 和 Visual 模式下都可以触发
vim.keymap.set({"n", "v"}, "<leader>c", function()
    snacks_ai_independent_input()
end, { desc = "AI Input with Toggle [AI:agent]" })
