# Neovim Configuration

> 使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 作为插件管理器的现代化 Neovim 配置

## 特性概览

- ⚡ **快速启动** - 使用 lazy.nvim 实现按需加载
- 🎨 **美观主题** - Tokyo Night 透明主题
- 🔍 **高效搜索** - LeaderF 模糊搜索 + snacks.nvim 组件
- 🧠 **智能补全** - 基于 nvim-cmp 的 LSP 补全
- 🤖 **AI 助手** - CodeCompanion.nvim 集成
- 📜 **语法高亮** - Tree-sitter 驱动
- 🔧 **LSP 支持** - C/C++、Python、Go、Rust 等语言
- ❓ **快捷键提示** - which-key.nvim 实时显示可用快捷键

## 基础设置

| 设置项 | 值 |
|--------|-----|
| Leader 键 | `<Space>` |
| Local Leader 键 | `,` |
| 缩进宽度 | 4 空格（Tab） |
| 行号 | 相对行号 |
| 主题 | Tokyo Night (Storm) |

## 快捷键速查

### 文件与搜索

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-p>` | Normal | 模糊搜索文件 |
| `<C-e>` | Normal | 搜索当前文件函数 |
| `<C-l>` | Normal | 搜索当前文件行 |
| `<leader>w` | Normal | 搜索光标下单词（rg） |
| `<leader>g` | Normal | 搜索输入内容（rg） |

### LSP 代码导航

| 快捷键 | 功能 |
|--------|------|
| `<C-]>` | 跳转到定义 |
| `<C-d>` | 跳转到实现 |
| `<C-M>` | 显示悬停文档 |
| `<C-k>` | 显示函数签名 |
| `<C-c>` | 查看出向调用 |
| `<space>r` | 查找引用 |
| `<space>n` | 重命名符号 |
| `<leader>d` | 打开诊断浮动窗口 |

### AI 助手 (CodeCompanion)

#### 基础操作

| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-n>` | Normal | 新建 AI 会话 |
| `<leader>a` | Visual | 添加选中内容到会话 |
| `<leader>e` | Normal/Visual | 执行 AI 命令（直接修改文件） |
| `<leader>c` | Normal/Visual | 打开 AI 输入框 |

#### 代码变更 Accept/Reject（Diff 模式）

当 AI 对文件进行修改后，会进入 Diff 模式显示变更：

| 快捷键 | 功能 |
|--------|------|
| `gda` | **Accept** - 接受当前更改并保存 |
| `gdr` | **Reject** - 拒绝当前更改，恢复原内容 |
| `gdy` | **Always Accept** - 始终接受此缓冲区的更改 |
| `q` | Stop - 停止请求 |

#### Chat 缓冲区快捷键

| 快捷键 | 功能 |
|--------|------|
| `?` | 显示所有选项 |
| `<CR>` / `<C-s>` | 发送消息 |
| `gr` | 重新生成响应 |
| `<C-c>` | 关闭 Chat |
| `q` | 停止生成 |
| `gx` | 清空对话 |
| `gc` | 插入代码块 |
| `gy` | 复制代码 |
| `gba` | 切换缓冲区同步 |
| `gbd` | 切换缓冲区 Diff 同步 |
| `ga` | 切换 Adapter/模型 |
| `gf` | 折叠代码 |
| `gD` | 显示 Super Diff（批量管理多文件变更） |
| `gtx` | 清除工具审批状态 |
| `gty` | 切换 YOLO 模式 |

#### ACP 权限请求（工具调用确认）

当 AI 需要执行工具（如运行命令、修改文件）时会弹出权限请求：

| 快捷键 | 功能 |
|--------|------|
| `g1` | Allow Always - 始终允许该工具 |
| `g2` | Allow Once - 允许一次 |
| `g3` | Reject Once - 拒绝一次 |
| `g4` | Reject Always - 始终拒绝该工具 |

### Git 操作

| 快捷键 | 功能 |
|--------|------|
| `<localleader>g` | 打开 GV（Git 日志浏览器） |
| `<leader>b` | Git Blame |

### Which-Key 快捷键提示

本配置使用 [which-key.nvim](https://github.com/folke/which-key.nvim) 提供交互式快捷键提示：

| 按键 | 功能说明 |
|------|----------|
| `<leader>` (空格) | 显示所有以 `<leader>` 开头的快捷键 |
| `<leader>?` | 显示缓冲区本地快捷键 |

**使用示例：**
1. 按下 `<leader>` (空格键) ，会弹出窗口显示所有以空格开头的快捷键
2. 继续按 `w` 即可执行搜索光标下单词的功能
3. 如果想查看更多快捷键，按 `<leader>?` 可以看到完整的快捷键列表

---

### 其他

| 快捷键 | 功能 |
|--------|------|
| `<leader>t` | 修剪行尾空白字符 |

### 补全快捷键（插入模式）

| 快捷键 | 功能 |
|--------|------|
| `<C-Space>` | 触发补全 |
| `<CR>` | 确认选择 |
| `<Tab>` | 下一个候选 |
| `<S-Tab>` | 上一个候选 |
| `<C-d>` | 向上滚动文档 |
| `<C-f>` | 向下滚动文档 |

## 插件列表

### 界面与主题
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - 配色主题
- [eleline.vim](https://github.com/liuchengxu/eleline.vim) - 轻量状态栏
- [which-key.nvim](https://github.com/folke/which-key.nvim) - 快捷键提示

### 搜索与导航
- [LeaderF](https://github.com/Yggdroot/LeaderF) - 模糊搜索神器
- [snacks.nvim](https://github.com/folke/snacks.nvim) - 现代化 UI 组件

### 代码智能
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP 配置
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - 补全引擎
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 语法解析

### AI 集成
- [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) - AI 助手
- [fidget.nvim](https://github.com/j-hui/fidget.nvim) - LSP 状态指示

### 编辑增强
- [rainbow-delimiters.nvim](https://github.com/hiphish/rainbow-delimiters.nvim) - 彩虹括号
- [targets.vim](https://github.com/wellle/targets.vim) - 文本对象增强
- [vim-interestingwords](https://github.com/lfv89/vim-interestingwords) - 单词高亮
- [whitespace.nvim](https://github.com/johnfrankmorgan/whitespace.nvim) - 空白处理

### Git 工具
- [vim-fugitive](https://github.com/tpope/vim-fugitive) - Git 命令包装器
- [gv.vim](https://github.com/junegunn/gv.vim) - Git 提交浏览器

### 其他
- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) - Quickfix 窗口增强
- [toggle-lsp-diagnostics.nvim](https://github.com/ColinKennedy/toggle-lsp-diagnostics.nvim) - 诊断控制

## 支持的 LSP 服务器

| 语言 | LSP 服务器 |
|------|-----------|
| C/C++ | `clangd` |
| Python | `pyright` |
| Go | `gopls` |
| Rust | `rust_analyzer` |

## 目录结构

```
.
├── init.lua                      # 入口文件 - 加载配置和插件
├── lazy-lock.json               # 插件版本锁定
├── README.md                    # 本文档
├── AGENTS.md                    # AI 代理开发指南
└── lua/
    ├── config/
    │   ├── lazy.lua            # lazy.nvim 插件管理器配置
    │   └── options.lua         # 基础 Vim 选项、键位映射、自动命令
    └── plugins/
        ├── init.lua            # 核心插件配置 (主题、AI、Git 等)
        ├── cmp.lua             # 代码补全引擎 (nvim-cmp) 配置
        ├── lsp.lua             # LSP 服务器配置 (clangd, pyright 等)
        └── codecompanion-fidget.lua  # AI 状态指示器配置
```

> **配置文件说明：**
> - `lua/config/options.lua` - 包含所有基础设置、键位映射、自动命令，注释详细，方便修改
> - `lua/plugins/*.lua` - 插件配置文件，每个文件顶部有功能说明和配置注释

## 安装

### 前置依赖

- Neovim >= 0.10
- Git
- 语言服务器（按需安装）：
  - `clangd` - C/C++
  - `pyright` - Python
  - `gopls` - Go
  - `rust-analyzer` - Rust

### 快速开始

```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.backup

# 克隆配置
git clone <your-repo-url> ~/.config/nvim

# 启动 Neovim，lazy.nvim 会自动安装插件
nvim
```

## 自定义

编辑 `lua/config/options.lua` 调整基础设置，或在 `lua/plugins/` 目录下添加新的插件配置。

## 许可证

MIT License
