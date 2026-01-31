# Neovim 配置

本配置使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 作为插件管理器，从 vim-plug 迁移而来。

## 基础设置

- **Leader 键**: `<Space>`
- **Local Leader 键**: `,`

---

## 快捷键列表

### 文件搜索 (LeaderF)

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-e>` | Normal | 搜索当前文件的函数 |
| `<C-p>` | Normal | 搜索文件 |
| `<C-l>` | Normal | 搜索当前文件的行 |
| `<leader>w` | Normal | 搜索当前光标下的单词 (rg) |
| `<leader>g` | Normal | 搜索输入内容 (rg) |

### Git 相关

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<localleader>g` | Normal | 打开 GV (Git 提交日志) |
| `<leader>b` | Normal | 打开 Git blame |

### LSP (语言服务器协议)

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-]>` | Normal | 跳转到定义 |
| `<C-M>` | Normal | 显示悬停文档 |
| `<C-d>` | Normal | 跳转到实现 |
| `<C-c>` | Normal | 查看出向调用 |
| `<C-k>` | Normal | 显示函数签名帮助 |
| `<space>r` | Normal | 查找引用 |
| `<space>n` | Normal | 重命名符号 |

### 代码补全 (nvim-cmp)

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-d>` | Insert | 向上滚动补全文档 |
| `<C-f>` | Insert | 向下滚动补全文档 |
| `<C-Space>` | Insert | 手动触发补全 |
| `<CR>` | Insert | 确认当前选中的补全项 |
| `<Tab>` | Insert | 选择下一个补全项 |
| `<S-Tab>` | Insert | 选择上一个补全项 |

### AI 助手 (CodeCompanion)

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-n>` | Normal | 新建 CodeCompanionChat 会话 |
| `<leader>a` | Visual | 添加选中的内容到 CodeCompanionChat |
| `<leader>e` | Normal/Visual | 执行 CodeCompanion 命令, 会直接修改当前文件，主要用来快速修改代码 |
| `<leader>c` | Normal/Visual | 打开 AI 输入框 (带 Toggle 功能) |

### 其他工具

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>` | Normal | 显示 WhichKey 帮助 |
| `<leader>d` | Normal | 打开诊断浮动窗口 |
| `<leader>t` | Normal | 修剪行尾空白字符 |
| `<F5>` | Normal | 隐藏 popup 窗口 |

---

## 插件列表

### 主题与界面
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - 主题
- [eleline.vim](https://github.com/liuchengxu/eleline.vim) - 状态栏

### 文件搜索与导航
- [LeaderF](https://github.com/Yggdroot/LeaderF) - 模糊文件/内容搜索
- [snacks.nvim](https://github.com/folke/snacks.nvim) - 输入框、文件选择器

### LSP 与代码补全
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP 配置
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - 补全引擎
- [toggle-lsp-diagnostics.nvim](https://github.com/ColinKennedy/toggle-lsp-diagnostics.nvim) - LSP 诊断控制

### AI 助手
- [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) - AI 聊天助手
- [fidget.nvim](https://github.com/j-hui/fidget.nvim) - LSP/状态通知

### Git
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Git 包装器
- [gv.vim](https://github.com/junegunn/gv.vim) - Git 提交浏览器

### 编辑增强
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 语法高亮
- [rainbow-delimiters.nvim](https://github.com/hiphish/rainbow-delimiters.nvim) - 彩虹括号
- [vim-interestingwords](https://github.com/lfv89/vim-interestingwords) - 高亮单词
- [targets.vim](https://github.com/wellle/targets.vim) - 文本对象增强
- [whitespace.nvim](https://github.com/johnfrankmorgan/whitespace.nvim) - 空白字符处理
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) - 快速修复窗口增强

---

## LSP 服务器

本配置支持以下 LSP 服务器：

- **clangd** - C/C++
- **pyright** - Python
- **gopls** - Go
- **rust_analyzer** - Rust

---

## 配置文件结构

```
.
├── init.lua                 # 入口文件
├── lua/
│   ├── config/
│   │   ├── lazy.lua        # lazy.nvim 配置
│   │   └── options.lua     # 基础设置与键位映射
│   └── plugins/
│       ├── init.lua        # 基础插件配置
│       ├── cmp.lua         # 补全配置
│       ├── lsp.lua         # LSP 配置
│       └── codecompanion-fidget.lua  # AI 状态指示器
└── lazy-lock.json          # 插件版本锁定
```
