-- ============================================
-- 基础 Vim 配置
-- 从 init.vim.bak 迁移
-- ============================================

local opt = vim.opt
local g = vim.g

-- Python 3 provider 配置
vim.g.python3_host_prog = "/usr/bin/python3"

-- 启用鼠标支持（仅 normal/visual 模式，方便终端复制）
vim.o.mouse = 'nv'
vim.opt.jumpoptions = "stack"

-- 基本设置
opt.clipboard:append("unnamedplus")
opt.clipboard:append("unnamed")
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    -- vim.highlight.on_yank()
    local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
    copy_to_unnamedplus(vim.v.event.regcontents)
    local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
    copy_to_unnamed(vim.v.event.regcontents)
  end,
})
opt.completeopt = { "menu", "menuone", "noselect", "preview" }
opt.fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936"
-- termencoding 在 Neovim 中不支持，使用环境变量
vim.env.LANG = "en_US.UTF-8"
opt.encoding = "utf-8"



-- 界面设置
opt.number = true
opt.relativenumber = true
opt.cursorline = false
-- syntax 启用是自动的，使用 vim.cmd 来确保
vim.cmd("syntax on")
opt.laststatus = 2
opt.splitright = true
opt.hidden = true

-- 缩进设置
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.shiftround = true
opt.expandtab = false
opt.cindent = true
opt.smartindent = true
opt.autoindent = true

-- 搜索设置
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- 其他设置
opt.backup = false
opt.backspace = { "indent", "eol", "start" }
opt.tags = "./.tags;"
opt.mouse = "nv"
opt.mousemodel = "extend"
opt.autoread = true

-- 确保显示部分输入的命令（右下角）
opt.showcmd = true
-- 禁用延迟重绘，确保命令行立即显示
opt.lazyredraw = false
-- 命令行高度
opt.cmdheight = 1

-- ============================================
-- 自动命令
-- ============================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd


vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line = mark[1]
        if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Makefile 使用 tab
autocmd("FileType", {
    pattern = "make",
    command = "setlocal noexpandtab",
})

-- 关闭补全后关闭预览窗口
autocmd("CompleteDone", {
    pattern = "*",
    command = "if pumvisible() == 0 | pclose | endif",
})

-- 禁用 .h 文件的诊断
autocmd({"BufEnter", "BufWinEnter", "BufRead", "BufReadPre", "FileReadPre"}, {
    pattern = ".h",
    callback = function(args)
        vim.diagnostic.enable(false, { bufnr = args.buf })
    end,
})

-- 设置 .ic 和 .i.*.CU 文件类型为 cpp
autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.ic", "*.i.*.CU"},
    command = "set filetype=cpp",
})

-- ============================================
-- 自定义函数
-- ============================================

-- 查找光标所在的 popup 窗口
function _G.FindCursorPopUp(radius)
    radius = radius or 2
    local srow = vim.fn.screenrow()
    local scol = vim.fn.screencol()
    
    for r = srow - radius, srow + radius do
        for c = scol - radius, scol + radius do
            local winid = vim.fn.popup_locate(r, c)
            if winid ~= 0 then
                return winid
            end
        end
    end
    return 0
end

-- 滚动 popup 窗口
function _G.ScrollPopUp(down)
    local winid = _G.FindCursorPopUp()
    if winid == 0 then
        return false
    end
    
    local pp = vim.fn.popup_getpos(winid)
    vim.fn.popup_setoptions(winid, {
        firstline = pp.firstline + (down and 25 or -25)
    })
    return true
end

-- 隐藏 popup 窗口
function _G.HidePopup()
    local winid = _G.FindCursorPopUp()
    vim.fn.popup_close(winid)
    return true
end

-- ============================================
-- 键位映射
-- ============================================

local map = vim.keymap.set

-- LeaderF 键位
map("n", "<C-e>", [[:<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>]], { silent = true })
map("n", "<C-p>", ":LeaderfFile<CR>", { silent = true })
map("n", "<C-l>", [[:<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>]], { silent = true })
map("n", "<leader>w", [[:<C-U><C-R>=printf("Leaderf! rg %s", expand("<cword>"))<CR><CR>]], { silent = false })
map("n", "<leader>g", [[:<C-U><C-R>=printf("Leaderf rg %s", "")<CR>]], { silent = false })
--map("n", "<leader>f", [[:<C-U><C-R>=printf("Leaderf self %s", "")<CR><CR>]], { silent = true })
--map("n", "<leader>t", [[:<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>]], { silent = true })
--map("n", "<leader>s", [[:<C-U><C-R>=printf("Leaderf! gtags -r ")<CR>]], { silent = true })
--map("n", "<leader>l", [[:<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>]], { silent = true })
--map("n", "<leader>p", ":LeaderfFile<CR>", { silent = true })

-- Git 键位
map("n", "<localleader>g", ":GV<CR>", { silent = true })
map("n", "<leader>b", ":Git blame<CR>", { silent = true })

-- WhichKey（延迟显示，避免干扰命令行）
map("n", "<leader>", ":WhichKey '<Space>'<CR>", { silent = true })

-- 诊断
map("n", "<leader>d", function() vim.diagnostic.open_float() end, { silent = true })

-- Popup 窗口
map("n", "<F5>", function() return _G.HidePopup() and "<esc>" or "<esc>" end, { expr = true })

-- ============================================
-- 全局变量设置
-- ============================================

-- Rainbow 括号
g.rainbow_active = 1

-- WhichKey 超时（增加到 500ms，避免过快弹出）
g.which_key_timeout = 500

-- Ccls 设置
g.ccls_close_on_jump = true
g.ccls_levels = 2
g.ccls_size = 40
g.ccls_position = "botleft"
g.ccls_orientation = "vertical"

-- LeaderF 设置
g.Lf_ShowDevIcons = 0
g.Lf_PreviewInPopup = 1
g.Lf_WindowPosition = "popup"
g.Lf_GtagsAutoGenerate = 0
g.Lf_CacheDirectory = vim.fn.expand("~/.cache/")
g.Lf_UseVersionControlTool = 0
g.Lf_WindowHeight = 0.3
g.Lf_PopupWidth = 0.75
g.Lf_WildIgnore = {
    dir = { ".git", "deps" },
    file = { "*.sw?", "*.o", "*.so.*", "*.so", "*.py[co]" }
}
g.Lf_DefaultMode = "FullPath"
g.Lf_MruFileExclude = { "*.sw?", "*.o", "*.so.*", "*.so", "*.py[co]" }
g.Lf_PopupPosition = { 1, 0 }
g.Lf_PopupPreviewPosition = "bottom"

-- GTAGS 设置
vim.env.GTAGSLABEL = "native-pygments"
vim.env.GTATGSCONF = "/usr/share/global/gtags/gtags.conf"

-- opencode 设置
g.opencode_opts = {}

-- Tagbar Go 配置
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

local function snacks_ai_independent_input()
  local snacks = require("snacks")
  local cc = require("codecompanion")

  local actual_width = 0.5
  actual_width = math.floor(vim.o.columns * actual_width)

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

    local chat = cc.last_chat()

    if chat and chat.ui:is_active() then
      process_input(chat)
    end

  end)
end

-- 绑定快捷键，例如 <leader>ai
vim.keymap.set("n", "<leader>i", snacks_ai_independent_input, { desc = "AI Input with Toggle" })

