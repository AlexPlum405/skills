<sub>🌐 <a href="README.en.md">English</a> · <b>中文</b></sub>

<div align="center">

# Auto Role Router

> **让 AI 编程助手在回答前先"进入专家角色"的 hooks 配置**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.1-blue.svg)](CHANGELOG.md)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)](#兼容性)
[![CI](https://img.shields.io/github/actions/workflow/status/AlexPlum405/skills/validate-hooks.yml?label=hooks%20CI)](https://github.com/AlexPlum405/skills/actions/workflows/validate-hooks.yml)

[特性](#为什么使用) • [安装](#安装) • [详细文档](SKILL.md)

</div>

---

## 这是什么

一套 Claude Code / Codex hooks 配置：在每次回答前，让 AI **先分析问题所属领域 → 构造最贴切的专家角色 → 带着这个角色去回答**，而不是边答边贴标签。

> **这不是一个普通“调用型 skill”**，而是一份自动生效的 hooks 配置。Claude Code 装到 `~/.claude/settings.json`，Codex 装到 `~/.codex/hooks.json`。装一次，每轮都跑。

**示例：**

```
用户：这个 Rust lifetime 错误怎么修？
AI：**角色：Rust Lifetime Expert**
   编译器报错是因为……（已以 lifetime 专家视角在回答）
```

```
用户：那 PostgreSQL 里这个查询怎么优化？
AI：**角色：PostgreSQL Query Optimizer**
   先看执行计划……（领域切换，角色自动重选）
```

## 为什么使用

- ✅ **预激活而不是事后贴标签** —— 回答第一个 token 就已经在专家模式
- ✅ **动态角色生成** —— 无需维护角色库，新框架自动适配
- ✅ **跨领域自动切换** —— 多轮对话中领域变了，角色跟着换
- ✅ **粒度自适应** —— 问题越具体角色越窄，问题宽泛角色就粗
- ✅ **跨平台** —— macOS / Linux / Windows 都有对应的安装脚本

## 工作原理

装好后，每条用户消息进入助手前会触发 `UserPromptSubmit` hook，向 system context 注入一段强制流程：

1. 从问题里**提取技术关键词**（语言、框架、工具、概念）
2. **判断粒度**：具体问题 → 细角色；宽泛问题 → 粗角色
3. 用公式**构造角色**：`[技术] + [专业方向] + Expert/Specialist`
4. **先进入角色再生成**输出，第一行声明 `**角色：XXX**`

详细方法论见 [SKILL.md](SKILL.md)。

## 安装

### Codex / Codex Desktop（已实测）

本仓库的 `hooks-config.json` 可直接作为 Codex 全局 hooks 配置使用，事件名仍是 `SessionStart` 和 `UserPromptSubmit`。

clone 后安装：

```bash
git clone https://github.com/AlexPlum405/skills.git
cd skills/auto-role-router
./install.sh --target codex --dry-run
./install.sh --target codex
```

如果是本地路径安装：

```bash
cd /Users/Alex/skills-repo/auto-role-router
./install.sh --target codex
```

安装位置：

```bash
~/.codex/hooks.json
```

验证建议走真实执行路径：

```bash
codex exec --skip-git-repo-check -s danger-full-access \
  -c approval_policy='"never"' \
  '这个 React Hook 怎么用？请只输出你的第一行，不要解释。' </dev/null
```

期望能看到：

```text
hook: SessionStart
hook: SessionStart Completed
hook: UserPromptSubmit
hook: UserPromptSubmit Completed
角色：React Hooks 专家
```

如果还想让 Codex 的技能列表里显示这个包，把整个目录同步到：

```bash
~/.codex/skills/auto-role-router
```

> 经验点：`codex debug prompt-input` 能确认 skill 是否被发现，但不一定展示 hook 注入内容；验证 hooks 是否真的执行，用 `codex exec` 更可靠。

### Claude Code

> 安装脚本会先把你现有的 `~/.claude/settings.json` 备份到带时间戳的 `.backup` 文件，再合并 hooks。支持 `--dry-run`，想先看改动再落盘。

#### macOS / Linux

```bash
curl -sSL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash
```

或者先 clone 再本地跑：

```bash
git clone https://github.com/AlexPlum405/skills.git
cd skills/auto-role-router
./install.sh --dry-run    # 先看会改什么
./install.sh              # 确认无误再装
```

#### Windows（PowerShell）

```powershell
# 需要 PowerShell 5.1+（Windows 10/11 自带）
irm https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.ps1 | iex
```

或 clone 后本地跑：

```powershell
git clone https://github.com/AlexPlum405/skills.git
cd skills\auto-role-router
.\install.ps1 -DryRun
.\install.ps1
```

### 高级选项

| 场景 | macOS/Linux | Windows |
|------|-------------|---------|
| 预览改动不落盘 | `./install.sh --dry-run` | `.\install.ps1 -DryRun` |
| 安装到 Codex | `./install.sh --target codex` | 暂不支持 |
| 安装到 Claude Code | `./install.sh --target claude` | `.\install.ps1` |
| 彻底卸载（保留别人的 hooks） | `./install.sh --uninstall` | `.\install.ps1 -Uninstall` |
| 使用更轻量的 legacy 配置 | `./install.sh --legacy` | `.\install.ps1 -Legacy` |

> `--legacy` 对应更短的 hook payload，只提醒 AI 声明角色，不强制"预激活"。效果差异见 [COMPARISON.md](COMPARISON.md)。新用户不推荐。

### 卸载

```bash
# macOS/Linux
./install.sh --uninstall

# Windows
.\install.ps1 -Uninstall
```

卸载脚本会用命令内容里的 `auto-role-router` 标识精准识别，只删自己的 hook entry，保留你安装的其他 hooks。

## 示例对话

**具体技术问题（细粒度角色）：**
```
用户：我的 Rust 异步函数因为 lifetime 问题编译不过
AI：**角色：Rust Lifetime Expert**
   编译器报错是因为……
```

**新技术（动态生成，无需预定义列表）：**
```
用户：怎么配置 Bun 内置的测试运行器？
AI：**角色：Bun Runtime Expert**
   Bun 的测试运行器可以这样配置……
```

**领域切换：**
```
用户：这个 PostgreSQL 查询怎么优化？
AI：**角色：PostgreSQL Query Optimizer**
   先看执行计划……

用户：那用 Redis 怎么缓存结果？
AI：**角色：Redis Caching Specialist**
   这个场景我建议……
```

## 兼容性

| AI 助手 | 状态 |
|--------|------|
| Claude Code（CLI/IDE 插件） | ✅ 完整测试并在 CI 中持续验证 |
| Codex / Codex Desktop | ✅ 本地实测：`~/.codex/hooks.json` + `codex exec` 可触发 `SessionStart` / `UserPromptSubmit` |

> **说明：** 其他助手（Cursor 等）的 hook 机制各不相同，这个仓库暂未验证。如果你测过兼容性并愿意分享步骤，欢迎提 PR。

## 故障排除

### 每轮都被拦截报 `unexpected EOF`

说明 hook 命令里存在英文撇号（`'`），bash 会把它当作单引号闭合导致解析失败。打开 `~/.claude/settings.json`，把 `hasn't` / `don't` / `it's` / `expert's` 改写成 `has not` / `do not` / `it is` / `the ... of the expert`，然后重启 Claude Code。

本仓库的 CI 会自动拦截这类问题，所以只在你自己手改 settings 时才可能踩到。

### AI 没声明角色

1. Claude Code：`jq .hooks ~/.claude/settings.json` 看 hooks 是否装进去了
2. Codex：`jq .hooks ~/.codex/hooks.json` 看 hooks 是否装进去了
3. 重启对应助手（hooks 是在 session 启动时加载的）
4. Codex 用 `codex exec ...` 看日志里是否出现 `hook: SessionStart` 和 `hook: UserPromptSubmit`

### 角色太泛化

问题给得越具体，角色越贴合：
- ❌ "Rust 怎么用？" → `Rust Expert`
- ✅ "我的 Rust 异步函数里的生命周期错误怎么修？" → `Rust Lifetime Expert`

## 贡献

欢迎 PR：其他 AI 助手的兼容性验证、更精准的角色构造策略、新语言的文档翻译。详见仓库根目录的 [CONTRIBUTING.md](../CONTRIBUTING.md)。

## 许可证

MIT License
