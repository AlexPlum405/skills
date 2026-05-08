<div align="center">

# Auto Role Router

> **Hooks configuration for automatic expert role assignment in AI coding assistants**
> **AI 编程助手的自动专家角色分配 Hooks 配置**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet)](https://skills.sh)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](CHANGELOG.md)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)](#compatibility--兼容性)

[Features](#why-use-it--为什么使用) • [Installation](#installation--安装) • [Documentation](SKILL.md) • [Comparison](COMPARISON.md)

</div>

---

## What is this? / 这是什么？

A hooks configuration package that makes your AI assistant automatically identify its expert role for each question and display it at the start of every response.

一个 hooks 配置包，让你的 AI 助手自动识别每个问题的专家角色，并在每次回答开头显示。

**Not a callable skill** — This is a documentation and configuration package. Install once, works automatically.

**不是可调用的 skill** — 这是一个文档和配置包。安装一次，自动生效。

**Example / 示例:**

```
User: How do I fix this Rust lifetime error?
AI: **Role: Rust Lifetime Expert**

The issue here is...
```

```
用户：这个 SQL 查询怎么优化？
AI：**角色：数据库性能专家**

首先检查执行计划...
```

## Why use it? / 为什么使用？

✅ **Better context** — AI tailors responses to specific domains  
✅ **Consistency** — Maintains the same role across related questions  
✅ **Transparency** — Always know what perspective the AI is answering from  
✅ **Future-proof** — Uses dynamic role generation, works with any tech stack  
✅ **Cross-platform** — Works with Claude Code, Cursor, and other AI assistants

✅ **更好的上下文** — AI 针对特定领域定制回答  
✅ **一致性** — 在相关问题中保持同一角色  
✅ **透明度** — 始终知道 AI 从什么角度回答  
✅ **面向未来** — 使用动态角色生成，适用于任何技术栈  
✅ **跨平台** — 适用于 Claude Code、Cursor 等 AI 助手

## Key Feature: Dynamic Role Generation / 核心特性：动态角色生成

Unlike traditional approaches with fixed role libraries, auto-role-router uses **dynamic role generation**:

与使用固定角色库的传统方法不同，auto-role-router 使用**动态角色生成**：

- ✅ Works with **any technology**, including frameworks that don't exist yet
- ✅ No coverage gaps — if you can name it, the AI can role-play it
- ✅ Automatically adjusts granularity based on question specificity

- ✅ 适用于**任何技术**，包括尚不存在的框架
- ✅ 无覆盖盲区 — 只要你能说出名字，AI 就能扮演该角色
- ✅ 根据问题的具体程度自动调整粒度

**Examples of dynamically generated roles:**
- New runtime? → "Bun Runtime Expert"
- Specific issue? → "Rust Lifetime Expert"
- Broad question? → "Rust Expert"

**动态生成角色的示例：**
- 新运行时？→ "Bun Runtime Expert"
- 具体问题？→ "Rust Lifetime Expert"
- 宽泛问题？→ "Rust Expert"

## Installation / 安装

### Two versions available / 两个版本可选

**Basic version (recommended)** — Simple role declaration  
**基础版（推荐）** — 简单的角色声明

**Plan A version (advanced)** — Pre-activation mode for better first-response quality  
**方案 A 版（高级）** — 预激活模式，首次回答质量更好

See [COMPARISON.md](COMPARISON.md) for detailed comparison.  
详细对比见 [COMPARISON.md](COMPARISON.md)。

### Method 1: Quick install (Basic version) / 快速安装（基础版）

```bash
# Backup your settings
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# Download and install (requires curl and jq)
curl -sL https://raw.githubusercontent.com/AlexPlum405/skills/main/install.sh | bash
```

### Method 2: Install Plan A version / 安装方案 A 版本

```bash
# Backup your settings
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# Clone repo
git clone https://github.com/AlexPlum405/skills.git
cd auto-role-router

# Merge Plan A hooks
jq -s '.[0] * .[1]' ~/.claude/settings.json hooks-config-plan-a.json > ~/.claude/settings.json.tmp
mv ~/.claude/settings.json.tmp ~/.claude/settings.json

# Restart Claude Code
echo "✅ Installed! Restart Claude Code to activate."
```

### Method 3: Manual installation / 手动安装

1. **Clone this repo / 克隆仓库:**
   ```bash
   git clone https://github.com/AlexPlum405/skills.git
   cd auto-role-router
   ```

2. **Choose your version / 选择版本:**
   - Basic: `hooks-config.json`
   - Plan A: `hooks-config-plan-a.json`

3. **Copy hooks configuration / 复制 hooks 配置:**
   
   Open `~/.claude/settings.json` and merge the content from your chosen config file.
   
   打开 `~/.claude/settings.json` 并合并你选择的配置文件内容。

4. **Restart your AI assistant / 重启助手:**
   
   Restart Claude Code (or your AI assistant) for hooks to take effect.
   
   重启 Claude Code（或你的 AI 助手）以使 hooks 生效。

**Full installation guide:** See [SKILL.md](SKILL.md) for detailed instructions.

**完整安装指南：** 详见 [SKILL.md](SKILL.md)。

## How it works / 工作原理

Auto-role-router injects hooks into your AI assistant that execute before each response:

Auto-role-router 向你的 AI 助手注入 hooks，在每次回答前执行：

1. **Extract keywords** from the question (tech stack, framework, tool)
2. **Determine granularity** (specific issue → narrow role, broad question → general role)
3. **Construct role name** using formula: `[Tech] + [Specialization] + Expert/Specialist`
4. **Declare on first line** in the appropriate language

1. 从问题中**提取关键词**（技术栈、框架、工具）
2. **确定粒度**（具体问题 → 细粒度角色，宽泛问题 → 粗粒度角色）
3. 使用公式**构造角色名**：`[技术] + [专业方向] + Expert/Specialist`
4. 在第一行用适当语言**声明角色**

**See [SKILL.md](SKILL.md) for detailed methodology.**

**详细方法论见 [SKILL.md](SKILL.md)。**

## Example Conversations / 示例对话

### Specific technical issue / 具体技术问题
```
User: Why is my Rust async function not compiling due to lifetime issues?
AI: **Role: Rust Lifetime Expert**

The compiler is complaining because...
```

### New technology (not in any predefined list) / 新技术（不在任何预定义列表中）
```
User: How do I configure Bun's built-in test runner?
AI: **Role: Bun Runtime Expert**

Bun's test runner can be configured...
```

### Domain switch / 领域切换
```
User: How do I optimize this PostgreSQL query?
AI: **Role: PostgreSQL Query Optimizer**

First, let's examine the execution plan...

User: Now how do I cache this result in Redis?
AI: **Role: Redis Caching Specialist**

For this use case, I recommend...
```

## Compatibility / 兼容性

| AI Assistant | Status | Notes |
|--------------|--------|-------|
| Claude Code | ✅ Tested | Fully tested with hooks |
| Cursor | ⚠️ Theoretical | Should work if hooks are supported |
| Other assistants | ⚠️ Varies | Check if your assistant supports hooks |

## Troubleshooting / 故障排除

### AI not declaring roles / AI 不声明角色

1. Check hooks installation: `cat ~/.claude/settings.json | grep "auto-role-router"`
2. Restart your AI assistant
3. Verify JSON syntax: `jq . ~/.claude/settings.json`

1. 检查 hooks 安装：`cat ~/.claude/settings.json | grep "auto-role-router"`
2. 重启你的 AI 助手
3. 验证 JSON 语法：`jq . ~/.claude/settings.json`

### Roles too generic / 角色太泛化

Provide more specific details in your question:
- ❌ "How do I use Rust?"
- ✅ "How do I fix this Rust lifetime error in my async function?"

在问题中提供更具体的细节：
- ❌ "Rust 怎么用？"
- ✅ "我的 Rust 异步函数里的生命周期错误怎么修？"

## Uninstallation / 卸载

1. Open `~/.claude/settings.json`
2. Remove the `SessionStart` and `UserPromptSubmit` hooks related to auto-role-router
3. Restart your AI assistant

1. 打开 `~/.claude/settings.json`
2. 删除与 auto-role-router 相关的 `SessionStart` 和 `UserPromptSubmit` hooks
3. 重启你的 AI 助手

## Contributing / 贡献

Contributions welcome! 欢迎贡献！

- Installation scripts for other AI assistants
- Improved role construction logic
- Additional language support
- Better examples

- 其他 AI 助手的安装脚本
- 改进的角色构造逻辑
- 额外的语言支持
- 更好的示例

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## License / 许可证

MIT License - Free to use, modify, and distribute.

---

**Made with ❤️ for better AI-human collaboration**  
**为更好的 AI-人类协作而制作**
