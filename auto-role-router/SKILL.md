---
name: auto-role-router
description: >
  Install and adapt auto-role-router hooks for Claude Code and Codex. Automatically identifies
  technical domains and assigns appropriate expert roles via SessionStart and UserPromptSubmit.
  Use when configuring, validating, or troubleshooting role-routing hooks. 安装和适配
  auto-role-router hooks，用于 Claude Code / Codex 自动识别技术领域并分配专家角色。
---

# Auto Role Router

> **Installation Guide & Documentation**  
> **安装指引与文档**

This is primarily an installation/adaptation skill. Use it when a user wants auto-role-router installed, ported between assistants, or debugged.

这主要是一个安装和适配 skill：当用户要安装、迁移或排查 auto-role-router hooks 时使用。

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

### Codex / Codex Desktop

Codex 0.128.0 has a stable `codex_hooks` feature and accepts the same hook event names used by this package:

- `SessionStart`
- `UserPromptSubmit`

Use global Codex hooks:

```bash
~/.codex/hooks.json
```

Install locally:

```bash
cd /path/to/auto-role-router
./install.sh --target codex
```

Or manually copy the config:

```bash
mkdir -p ~/.codex
cp hooks-config.json ~/.codex/hooks.json
jq . ~/.codex/hooks.json
```

If the package itself should appear in Codex's skill list, copy the folder into the global skills directory:

```bash
mkdir -p ~/.codex/skills/auto-role-router
rsync -a --delete --exclude '.git/' --exclude '.DS_Store' ./ ~/.codex/skills/auto-role-router/
```

Validate with the real execution path, not only prompt rendering:

```bash
codex exec --skip-git-repo-check -s danger-full-access \
  -c approval_policy='"never"' \
  '这个 React Hook 怎么用？请只输出你的第一行，不要解释。' </dev/null
```

Expected evidence:

```text
hook: SessionStart
hook: SessionStart Completed
hook: UserPromptSubmit
hook: UserPromptSubmit Completed
角色：React Hooks 专家
```

Note: `codex debug prompt-input` is useful for confirming the skill list, but it may not show hook-injected context. Prefer `codex exec` for hook verification.

### Claude Code

Claude Code uses:

```bash
~/.claude/settings.json
```

Install locally:

```bash
cd /path/to/auto-role-router
./install.sh
```

The installer merges this package's hook entries into existing hooks instead of replacing unrelated hooks.

### Manual hook config / 手动配置

If you are adapting to another assistant with Claude-compatible hooks, copy from `hooks-config.json`:

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

Restart Claude Code, Codex, or the target assistant for hooks to take effect.

重启 Claude Code（或你的 AI 助手）以使 hooks 生效。

### Quick install script / 快速安装脚本

macOS / Linux:
```bash
curl -sSL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash
```

Codex target after clone:
```bash
./install.sh --target codex
```

Windows (PowerShell 5.1+):
```powershell
irm https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.ps1 | iex
```

The macOS/Linux installer backs up the target file first, supports `--target claude|codex`, `--dry-run`, `--legacy`, and `--uninstall`. The PowerShell installer currently targets Claude Code.

macOS/Linux 安装脚本会先备份目标文件，支持 `--target claude|codex`、`--dry-run`、`--legacy` 和 `--uninstall`。PowerShell 安装脚本目前面向 Claude Code。

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

1. **Check hooks installation**: Verify `~/.claude/settings.json` or `~/.codex/hooks.json` has the hooks section
2. **Restart**: Restart your AI assistant
3. **Check syntax**: Ensure JSON is valid (use `jq . ~/.claude/settings.json` or `jq . ~/.codex/hooks.json`)
4. **For Codex**: Run `codex exec` and look for `hook: SessionStart` plus `hook: UserPromptSubmit`

1. **检查 hooks 安装**：验证 `~/.claude/settings.json` 或 `~/.codex/hooks.json` 有 hooks 部分
2. **重启**：重启你的 AI 助手
3. **检查语法**：确保 JSON 有效（使用 `jq . ~/.claude/settings.json` 或 `jq . ~/.codex/hooks.json`）
4. **Codex**：用 `codex exec` 看是否出现 `hook: SessionStart` 和 `hook: UserPromptSubmit`

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

**Fix:** Open `~/.claude/settings.json` or `~/.codex/hooks.json` and rewrite any `hasn't` / `don't` / `it's` / `expert's` inside the hook command as `has not` / `do not` / `it is` / `the ... of the expert`. Then restart the target assistant.

**Verify before committing a hook:**
```bash
# Extract and execute the hook command. Swap in ~/.codex/hooks.json for Codex.
cmd=$(jq -r '.hooks.UserPromptSubmit[0].hooks[0].command' ~/.claude/settings.json)
bash -c "$cmd" > /dev/null && echo OK || echo BROKEN
```

如果看到 `UserPromptSubmit operation blocked by hook: ... unexpected EOF` 报错，说明 hook 命令里出现了英文撇号（`'`），它落在 bash 单引号包裹的 `printf` 字符串里会被当作闭合引号，导致 shell 解析失败。

**修法：** 打开 `~/.claude/settings.json` 或 `~/.codex/hooks.json`，把 hook 里的 `hasn't` / `don't` / `it's` / `expert's` 改写成 `has not` / `do not` / `it is` / `the ... of the expert`，然后重启目标助手。

---

## Uninstallation / 卸载

To remove auto-role-router:

```bash
./install.sh --target claude --uninstall
./install.sh --target codex --uninstall
```

Or manually remove the `SessionStart` and `UserPromptSubmit` entries related to auto-role-router, then restart the target assistant.

要移除 auto-role-router：

```bash
./install.sh --target claude --uninstall
./install.sh --target codex --uninstall
```

也可以手动删除与 auto-role-router 相关的 `SessionStart` 和 `UserPromptSubmit` entries，然后重启目标助手。

---

## Compatibility / 兼容性

| AI Assistant | Status |
|--------------|--------|
| Claude Code (CLI / IDE plugins) | ✅ Fully tested; continuously verified in CI on macOS, Linux, Windows |
| Codex / Codex Desktop | ✅ Locally verified with `~/.codex/hooks.json`; `codex exec` shows `SessionStart` and `UserPromptSubmit` completion |

> Hook mechanisms differ across other assistants (Cursor, etc.) and this repo has not verified them yet. If you test compatibility with another assistant and want to contribute install steps, PRs welcome.
>
> 其他助手（Cursor 等）的 hook 机制各不相同，本仓库暂未验证。如果你测过兼容性并愿意分享安装步骤，欢迎提 PR。

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
