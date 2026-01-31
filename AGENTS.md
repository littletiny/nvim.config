# NOTES
* 所有的插件代码都在 $HOME/.local/share/nvim/lazy 目录下
* 修改插件配置的时候优先阅读各个插件实现的命令，尽可能复用现有的命令实现，而不是重复实现，参考lua/config/options.lua中的**snacks_ai_independent_input**实现思路，复用CodecompanionChat Toggle而不是自己重写一套机制
* 当前用到的插件在${current_path}/lua/plugins/init.lua, 另外少部分配置在${current_path}/lua/config/options.lua
