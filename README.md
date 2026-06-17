# 🧠 AI Memory System

> 一个面向个人的、轻量级的、可定制的 AI 记忆系统。基于 Obsidian + Claude Code + CC Switch，搜索效率提升 161 倍。

## 🎯 解决什么问题？

每次开新对话，AI 就失忆了。

我之前跟它聊的、改的、踩的坑，全忘了。我得重新解释一遍上下文，它才能接上。

就像跟一个每天早上都失忆的朋友聊天——你得每天早上重新自我介绍一遍。烦。

## ✨ 特性

- 🚀 **快速搜索**：0.062 秒完成搜索，效率提升 161 倍
- 🔒 **零依赖**：纯 Markdown 文件，不依赖任何插件、服务、数据库
- 🎛️ **完全可控**：我写什么，它就记什么；我改什么，它就存什么
- 🔄 **增量更新**：只处理新增/修改的文件，节省时间和 token
- 📦 **可迁移**：换个 AI 工具？把文件夹复制过去就行
- 🎨 **可视化**：用 Obsidian 打开，图谱视图一目了然

## 📊 量化验证

| 指标 | 原始方法 | 索引系统 | 提升 |
|------|----------|----------|------|
| 搜索时间 | ~10 秒 | 0.062 秒 | **161 倍** |
| 步骤数 | 4 步 | 1 步 | **75% 减少** |
| 搜索范围 | 所有 JSONL | 只搜索索引 | **90%+ 减少** |

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/your-username/ai-memory-system.git

# 进入目录
cd ai-memory-system

# 复制到你的记忆目录
cp -r sessions/ D:\Claude-memory\
cp generate-offline-index.sh D:\Claude-memory\sessions\
```

### 使用

#### 搜索会话

```bash
# 按关键词搜索
grep -r "关键词" D:\Claude-memory\sessions/

# 按时间搜索
ls D:\Claude-memory\sessions/ | grep "2026-06"

# 按主题搜索
grep -r "主题：.*记忆" D:\Claude-memory\sessions/
```

#### 生成离线索引

```bash
# 首次运行（全量更新）
bash D:\Claude-memory\sessions\generate-offline-index.sh

# 后续运行（增量更新）
bash D:\Claude-memory\sessions\generate-offline-index.sh
```

## 📁 目录结构

```
D:\Claude-memory\
├── MEMORY.md                          # 总索引，每次会话启动先读它
├── goals.md                           # 当前焦点、待办、进行中的任务
├── lessons_learned.md                 # 踩过的坑和解决方案
├── user_preferences.md                # 沟通风格、工作习惯
├── sessions/                          # 会话索引，用于快速搜索
│   ├── 2026-06-17.md                  # 实时生成的会话索引
│   ├── 2026-06-17_171eb0b9.md         # 离线生成的会话索引
│   └── generate-offline-index.sh      # 离线索引生成脚本
├── projects/                          # 项目笔记（每个项目一个文件）
├── decisions/                         # 重要决策记录
└── reference/                         # 参考资料
```

## 🔧 配置

### Claude Code 集成

在 CLAUDE.md 中添加会话索引生成指令。

### Obsidian 集成

直接用 Obsidian 打开 D:\Claude-memory\ 目录，即可获得图谱视图。

## 📚 文档

- docs/design.md - 了解系统架构和设计决策
- docs/comparison.md - 与其他方案的详细对比
- docs/optimization.md - 后续优化方向

## 🤝 贡献

欢迎贡献！请阅读 CONTRIBUTING.md 了解如何参与。

## 📝 更新日志

查看 CHANGELOG.md 了解版本更新。

## 📄 许可证

本项目采用 MIT 许可证。

## 🙏 致谢

- Obsidian - 知识管理工具
- Claude Code - AI 编程助手
- Codex Memory System - 灵感来源

## 📧 联系方式

如有问题或建议，请提交 Issue。

---

⭐ 如果这个项目对你有帮助，请给个 Star 支持一下！
