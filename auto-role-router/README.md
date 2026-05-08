<sub>🌐 <a href="README.en.md">English</a> · <b>中文</b></sub>

<div align="center">

# Auto Role Router

> **AI 编程助手的自动专家角色分配 Hooks 配置**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet)](https://skills.sh)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](CHANGELOG.md)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)](#兼容性)

[特性](#为什么使用) • [安装](#安装) • [详细文档](SKILL.md) • [版本对比](COMPARISON.md)

</div>

---

## 这是什么

一个 hooks 配置包，让你的 AI 助手自动识别每个问题的专家角色，并在每次回答开头显示。

**不是可调用的 skill** —— 这是一个文档和配置包。安装一次，自动生效。

**示例：**

```
用户：这个 Rust lifetime 错误怎么修？
AI：**角色：Rust Lifetime Expert**

这个错误的原因是...
```

```
用户：这个 SQL 查询怎么优化？
AI：**角色：数据库性能专家**

首先检查执行计划...
```

## 为什么使用

- ✅ **更好的上下文** — AI 针对特定领域定制回答
- ✅ **一致性** — 在相关问题中保持同一角色
- ✅ **透明度** — 始终知道 AI 从什么角度回答
- ✅ **面向未来** — 使用动态角色生成，适用于任何技术栈
- ✅ **跨平台** — 适用于 Claude Code、Cursor 等 AI 助手

## 核心特性：动态角色生成

与使用固定角色库的传统方法不同，auto-role-router 使用**动态角色生成**：

- ✅ 适用于**任何技术**，包括尚不存在的框架
- ✅ 无覆盖盲区 —— 只要你能说出名字，AI 就能扮演该角色
- ✅ 根据问题的具体程度自动调整粒度

**动态生成角色的示例：**
- 新运行时？→ `Bun Runtime Expert`
- 具体问题？→ `Rust Lifetime Expert`
- 宽泛问题？→ `Rust Expert`

## 安装

### 两个版本可选

- **基础版（推荐）** —— 简单的角色声明
- **方案 A 版（高级）** —— 预激活模式，首次回答质量更好

详细对比见 [COMPARISON.md](COMPARISON.md)。

### 方式 1：快速安装（基础版）

```bash
# 备份现有配置
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# 一键安装（需要 curl 和 jq）
curl -sL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash
```

### 方式 2：安装方案 A 版本

```bash
# 备份现有配置
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# 克隆仓库
git clone https://github.com/AlexPlum405/skills.git
cd skills/auto-role-router

# 合并方案 A hooks
jq -s '.[0] * .[1]' ~/.claude/settings.json hooks-config-plan-a.json > ~/.claude/settings.json.tmp
mv ~/.claude/settings.json.tmp ~/.claude/settings.json

echo "✅ 已安装，重启 Claude Code 生效"
```

### 方式 3：手动安装

1. **克隆仓库：**
   ```bash
   git clone https://github.com/AlexPlum405/skills.git
   cd skills/auto-role-router
   ```

2. **选择版本：**
   - 基础版：`hooks-config.json`
   - 方案 A：`hooks-config-plan-a.json`

3. **复制 hooks 配置：** 打开 `~/.claude/settings.json`，合并你选择的配置文件内容。

4. **重启助手：** 重启 Claude Code（或你的 AI 助手）使 hooks 生效。

完整安装指南详见 [SKILL.md](SKILL.md)。

## 工作原理

Auto-role-router 向你的 AI 助手注入 hooks，在每次回答前执行：

1. 从问题中**提取关键词**（技术栈、框架、工具）
2. **确定粒度**（具体问题 → 细粒度角色，宽泛问题 → 粗粒度角色）
3. 使用公式**构造角色名**：`[技术] + [专业方向] + Expert/Specialist`
4. 在第一行用适当语言**声明角色**

详细方法论见 [SKILL.md](SKILL.md)。

## 示例对话

**具体技术问题：**
```
用户：我的 Rust 异步函数因为 lifetime 问题编译不过
AI：**角色：Rust Lifetime Expert**

编译器报错是因为...
```

**新技术（不在任何预定义列表中）：**
```
用户：怎么配置 Bun 内置的测试运行器？
AI：**角色：Bun Runtime Expert**

Bun 的测试运行器可以这样配置...
```

**领域切换：**
```
用户：这个 PostgreSQL 查询怎么优化？
AI：**角色：PostgreSQL Query Optimizer**

先看执行计划...

用户：那用 Redis 怎么缓存结果？
AI：**角色：Redis Caching Specialist**

这个场景我建议...
```

## 兼容性

| AI 助手 | 状态 | 说明 |
|--------|------|------|
| Claude Code | ✅ 已测试 | 完整测试通过 |
| Cursor | ⚠️ 理论兼容 | 如果支持 hooks 应该可用 |
| 其他助手 | ⚠️ 视情况 | 需确认助手是否支持 hooks |

## 故障排除

### AI 不声明角色

1. 检查 hooks 安装：`cat ~/.claude/settings.json | grep "auto-role-router"`
2. 重启你的 AI 助手
3. 验证 JSON 语法：`jq . ~/.claude/settings.json`

### 角色太泛化

在问题中提供更具体的细节：
- ❌ "Rust 怎么用？"
- ✅ "我的 Rust 异步函数里的生命周期错误怎么修？"

## 卸载

1. 打开 `~/.claude/settings.json`
2. 删除与 auto-role-router 相关的 `SessionStart` 和 `UserPromptSubmit` hooks
3. 重启你的 AI 助手

## 贡献

欢迎贡献：
- 其他 AI 助手的安装脚本
- 改进的角色构造逻辑
- 额外的语言支持
- 更好的示例

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可证

MIT License —— 可自由使用、修改和分发。

---

<div align="center">

**为更好的 AI-人类协作而制作**

</div>
