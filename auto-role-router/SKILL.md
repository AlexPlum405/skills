---
name: auto-role-router
description: >
  Installation guide and documentation for auto-role-router hooks. Automatically identifies
  technical domains and assigns appropriate expert roles. Not meant to be invoked as a skill.
  安装指引和文档，用于配置 auto-role-router hooks。自动识别技术领域并分配专家角色。
  不需要作为 skill 调用。
---

# Auto Role Router

> **Installation Guide & Documentation**  
> **安装指引与文档**

This is NOT a callable skill. It's a documentation package for installing auto-role-router hooks into your AI coding assistant.

这不是一个可调用的 skill，而是用于在你的 AI 编程助手中安装 auto-role-router hooks 的文档包。

---

## What it does / 功能说明

Auto-role-router makes your AI assistant automatically:
1. Identify the technical domain of each question
2. Assign itself the most appropriate expert role
3. Display that role at the start of every response

Auto-role-router 让你的 AI 助手自动：
1. 识别每个问题的技术领域
2. 为自己分配最合适的专家角色
3. 在每次回答开头显示该角色

**Key feature**: Uses **dynamic role generation** instead of a fixed role library, so it works with any technology stack, including new frameworks that didn't exist when this was created.

**核心特性**：使用**动态角色生成**而不是固定角色库，因此适用于任何技术栈，包括创建时还不存在的新框架。

---

## Installation / 安装

### Step 1: Locate your settings file / 找到配置文件

For Claude Code:
```bash
~/.claude/settings.json
```

For other AI assistants, find their equivalent configuration file.

对于其他 AI 助手，找到它们对应的配置文件。

### Step 2: Add hooks / 添加 hooks

Open `settings.json` and add the `hooks` section. If you already have hooks, merge them.

打开 `settings.json` 并添加 `hooks` 部分。如果已有 hooks，合并它们。

**Full hooks configuration** (copy from `hooks-config.json` in this repo):

完整 hooks 配置（从本仓库的 `hooks-config.json` 复制）：

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "printf '%s' '{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"# Auto Role Router - Session Rules\\n\\nEvery response MUST follow this workflow:\\n\\n## Step 1: Domain Identification\\nExtract technical keywords from the question:\\n- Programming languages (Rust, Python, TypeScript, etc.)\\n- Frameworks (React, Django, Spring, etc.)\\n- Tools (Git, Docker, Kubernetes, etc.)\\n- Concepts (async, performance, security, etc.)\\n\\n## Step 2: Role Assignment\\nConstruct a specific expert role using this formula:\\n**[Technology] + [Specialization] + Expert/Specialist**\\n\\nGranularity rules:\\n- Specific issue (e.g., \\\"lifetime error\\\") → Narrow role (\\\"Rust Lifetime Expert\\\")\\n- Broad question (e.g., \\\"how to learn Rust\\\") → General role (\\\"Rust Expert\\\")\\n- Unknown tech → Use the tech name directly (e.g., \\\"Deno Runtime Expert\\\")\\n\\n## Step 3: Role Declaration\\nFirst line of response MUST be:\\n- English: **Role: [Role Name]**\\n- Chinese: **角色：[角色名称]**\\n\\n## Step 4: Role Persistence\\n- Same domain → Keep current role\\n- Domain switch → Assign new role\\n\\nThis rule overrides brevity preferences. Non-compliance = violation.\"}}'",
            "timeout": 10
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "printf '%s' '{\"hookSpecificOutput\":{\"hookEventName\":\"UserPromptSubmit\",\"additionalContext\":\"# Auto Role Router - Mandatory Execution\\n\\nBefore answering, execute these steps:\\n\\n1. **Extract keywords**: Identify tech stack, framework, tool, or concept\\n2. **Determine granularity**:\\n   - Specific problem → Specific role (e.g., \\\"PostgreSQL Index Optimizer\\\")\\n   - General question → General role (e.g., \\\"Database Expert\\\")\\n3. **Construct role name**:\\n   - Format: [Tech] + [Specialization] + Expert/Specialist\\n   - Examples: \\\"React Hooks Specialist\\\", \\\"Kubernetes Networking Expert\\\"\\n   - For unknown tech: Use tech name + \\\"Expert\\\" (e.g., \\\"Bun Runtime Expert\\\")\\n4. **Declare on first line**:\\n   - English: **Role: XXX**\\n   - Chinese: **角色：XXX**\\n5. **Reuse if unchanged**: Keep role if domain hasn\\'t switched\\n\\nMissing role declaration = violation. Higher priority than brevity.\"}}'",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### Step 3: Restart your AI assistant / 重启助手

Restart Claude Code (or your AI assistant) for the hooks to take effect.

重启 Claude Code（或你的 AI 助手）以使 hooks 生效。

### Quick install script / 快速安装脚本

```bash
# Backup your current settings
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# Download and merge hooks (requires jq)
curl -sL https://raw.githubusercontent.com/AlexPlum405/skills/main/hooks-config.json | \
  jq -s '.[0] * .[1]' ~/.claude/settings.json - > ~/.claude/settings.json.tmp && \
  mv ~/.claude/settings.json.tmp ~/.claude/settings.json

echo "✅ Installed! Restart Claude Code to activate."
```

---

## How it works / 工作原理

### Dynamic Role Generation / 动态角色生成

Instead of a fixed role library, auto-role-router teaches the AI **how to construct roles** on the fly:

Auto-role-router 不使用固定角色库，而是教 AI **如何动态构造角色**：

#### Role Construction Formula / 角色构造公式

```
[Technology] + [Specialization] + Expert/Specialist
```

**Examples / 示例:**
- `Rust` + `Lifetime` + `Expert` → **Rust Lifetime Expert**
- `PostgreSQL` + `Query Optimization` + `Specialist` → **PostgreSQL Query Optimization Specialist**
- `React` + `Hooks` + `Specialist` → **React Hooks Specialist**
- `Kubernetes` + `Networking` + `Expert` → **Kubernetes Networking Expert**

#### Granularity Rules / 粒度规则

| Question Type | Role Granularity | Example |
|---------------|------------------|---------|
| Specific technical issue | Narrow, specialized | "Rust Lifetime Expert" |
| General question | Broad, general | "Rust Expert" |
| Unknown/new technology | Tech name + Expert | "Deno Runtime Expert" |
| Cross-domain question | Most relevant domain | "Full Stack Developer" |

### Why Dynamic Generation? / 为什么动态生成？

✅ **Future-proof**: Works with technologies that don't exist yet  
✅ **Comprehensive**: No gaps in coverage  
✅ **Lightweight**: No need to maintain a huge role library  
✅ **Precise**: Adapts to the specific question context

✅ **面向未来**：适用于尚不存在的技术  
✅ **全面覆盖**：没有覆盖盲区  
✅ **轻量级**：无需维护庞大的角色库  
✅ **精确**：根据具体问题上下文调整

---

## Example Conversations / 示例对话

### Example 1: Specific technical issue
```
User: Why is my Rust async function not compiling due to lifetime issues?
AI: **Role: Rust Lifetime Expert**

The compiler is complaining because...
```

### Example 2: New technology (not in any predefined list)
```
User: How do I configure Bun's built-in test runner?
AI: **Role: Bun Runtime Expert**

Bun's test runner can be configured...
```

### Example 3: Domain switch
```
User: How do I optimize this PostgreSQL query?
AI: **Role: PostgreSQL Query Optimizer**

First, let's examine the execution plan...

User: Now how do I cache this result in Redis?
AI: **Role: Redis Caching Specialist**

For this use case, I recommend...
```

### Example 4: Chinese question
```
用户：这个 React Hook 怎么用？
AI：**角色：React Hooks 专家**

这个 Hook 的用法是...
```

---

## Role Examples (Reference Only) / 角色示例（仅供参考）

These are examples to illustrate the pattern. The AI will generate roles dynamically, not select from this list.

这些示例仅用于说明模式。AI 会动态生成角色，而不是从此列表中选择。

### Programming Languages / 编程语言
- Rust Lifetime Expert, Rust Macro Specialist, Rust Async Expert
- Python Type Hints Specialist, Python Performance Optimizer
- TypeScript Generics Expert, TypeScript Compiler Specialist
- Go Concurrency Expert, Go Interface Designer

### Frameworks / 框架
- React Hooks Specialist, React Performance Optimizer
- Vue Composition API Expert, Vue Reactivity Specialist
- Next.js SSR Expert, Next.js App Router Specialist
- Django ORM Expert, Django Security Specialist

### Databases / 数据库
- PostgreSQL Query Optimizer, PostgreSQL Index Designer
- MongoDB Aggregation Expert, MongoDB Sharding Specialist
- Redis Caching Specialist, Redis Pub/Sub Expert

### Infrastructure / 基础设施
- Kubernetes Networking Expert, Kubernetes Security Specialist
- Docker Multi-stage Build Expert, Docker Compose Specialist
- Terraform Module Designer, Terraform State Management Expert

### Tools / 工具
- Git Rebase Expert, Git Conflict Resolution Specialist
- Claude Code Configuration Expert, Claude Code Skill Developer
- VS Code Extension Developer, VS Code Keybinding Specialist

---

## Troubleshooting / 故障排除

### AI not declaring roles / AI 不声明角色

1. **Check hooks installation**: Verify `~/.claude/settings.json` has the hooks section
2. **Restart**: Restart your AI assistant
3. **Check syntax**: Ensure JSON is valid (use `jq . ~/.claude/settings.json`)

1. **检查 hooks 安装**：验证 `~/.claude/settings.json` 有 hooks 部分
2. **重启**：重启你的 AI 助手
3. **检查语法**：确保 JSON 有效（使用 `jq . ~/.claude/settings.json`）

### Roles too generic / 角色太泛化

Provide more specific details in your question:
- ❌ "How do I use Rust?"
- ✅ "How do I fix this Rust lifetime error in my async function?"

在问题中提供更具体的细节：
- ❌ "Rust 怎么用？"
- ✅ "我的 Rust 异步函数里的生命周期错误怎么修？"

### Roles too specific / 角色太具体

Ask broader questions:
- ❌ "What's the syntax for this specific Rust macro?"
- ✅ "How do I learn Rust macros?"

提出更宽泛的问题：
- ❌ "这个 Rust 宏的语法是什么？"
- ✅ "Rust 宏怎么学？"

### Every turn is blocked with `unexpected EOF` / 每轮都被拦截报 `unexpected EOF`

If you see `UserPromptSubmit operation blocked by hook: ... unexpected EOF while looking for matching "'"`, your hook command contains an English apostrophe (`'`) inside the bash single-quoted `printf` payload. Bash treats the apostrophe as the end of the quoted string and fails.

**Fix:** Open `~/.claude/settings.json` and rewrite any `hasn't` / `don't` / `it's` / `expert's` inside the hook command as `has not` / `do not` / `it is` / `the ... of the expert`. Then restart Claude Code.

**Verify before committing a hook:**
```bash
# Extract and execute the hook command
cmd=$(jq -r '.hooks.UserPromptSubmit[0].hooks[0].command' ~/.claude/settings.json)
bash -c "$cmd" > /dev/null && echo OK || echo BROKEN
```

如果看到 `UserPromptSubmit operation blocked by hook: ... unexpected EOF` 报错，说明 hook 命令里出现了英文撇号（`'`），它落在 bash 单引号包裹的 `printf` 字符串里会被当作闭合引号，导致 shell 解析失败。

**修法：** 打开 `~/.claude/settings.json`，把 hook 里的 `hasn't` / `don't` / `it's` / `expert's` 改写成 `has not` / `do not` / `it is` / `the ... of the expert`，然后重启 Claude Code。

---

## Uninstallation / 卸载

To remove auto-role-router:

1. Open `~/.claude/settings.json`
2. Remove the `SessionStart` and `UserPromptSubmit` hooks related to auto-role-router
3. Restart your AI assistant

要移除 auto-role-router：

1. 打开 `~/.claude/settings.json`
2. 删除与 auto-role-router 相关的 `SessionStart` 和 `UserPromptSubmit` hooks
3. 重启你的 AI 助手

---

## Compatibility / 兼容性

| AI Assistant | Status | Notes |
|--------------|--------|-------|
| Claude Code | ✅ Tested | Fully tested with hooks |
| Cursor | ⚠️ Theoretical | Should work if hooks are supported |
| OpenAI Codex | ⚠️ Theoretical | May need adaptation |
| OpenCode | ⚠️ Theoretical | May need adaptation |
| OpenClaw | ⚠️ Theoretical | May need adaptation |

---

## Contributing / 贡献

This is a documentation package. Contributions welcome for:
- Installation scripts for other AI assistants
- Improved role construction logic
- Additional language support
- Better examples

这是一个文档包。欢迎贡献：
- 其他 AI 助手的安装脚本
- 改进的角色构造逻辑
- 额外的语言支持
- 更好的示例

---

## License / 许可证

MIT License - Free to use, modify, and distribute.

---

**Made with ❤️ for better AI-human collaboration**  
**为更好的 AI-人类协作而制作**
