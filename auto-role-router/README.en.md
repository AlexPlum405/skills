<sub>🌐 <b>English</b> · <a href="README.md">中文</a></sub>

<div align="center">

# Auto Role Router

> **Hooks that put your Claude Code agent *into* an expert role before it starts replying — not after.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.1-blue.svg)](CHANGELOG.md)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)](#compatibility)
[![CI](https://img.shields.io/github/actions/workflow/status/AlexPlum405/skills/validate-hooks.yml?label=hooks%20CI)](https://github.com/AlexPlum405/skills/actions/workflows/validate-hooks.yml)

[Features](#why-use-it) • [Install](#install) • [Docs](SKILL.md)

</div>

---

## What is this

A Claude Code / Codex hooks config that runs on every user turn: **analyze domain → construct the most specific expert role → adopt that role before generating the first token**. Not "label the answer with a role after the fact" — actually enter the role first.

> **This is not a normal callable skill.** It is an auto-loaded hooks config. Claude Code uses `~/.claude/settings.json`; Codex uses `~/.codex/hooks.json`. Install once; it runs automatically.

**Example:**

```
You:  How do I fix this Rust lifetime error?
AI:   **Role: Rust Lifetime Expert**
      The borrow checker is complaining because… (already thinking as a lifetime expert)
```

```
You:  Then how do I optimize this PostgreSQL query?
AI:   **Role: PostgreSQL Query Optimizer**
      Let's look at the execution plan… (domain switched, role re-selected)
```

## Why use it

- ✅ **Pre-activation, not post-labeling** — the agent is in role from the first token
- ✅ **Dynamic role generation** — no role library to maintain; new frameworks work out of the box
- ✅ **Auto domain switching** — multi-turn conversations keep the role in sync with the topic
- ✅ **Granularity-aware** — specific question gets a narrow role, broad question gets a wide one
- ✅ **Cross-platform** — installer for macOS, Linux, and Windows

## How it works

After install, every user prompt fires the `UserPromptSubmit` hook, which injects a forced workflow into the system context:

1. **Extract** the tech keywords (language, framework, tool, concept)
2. **Decide granularity** — specific issue → narrow role; broad question → broad role
3. **Construct** the role: `[Tech] + [Specialization] + Expert/Specialist`
4. **Enter the role before generating**; declare `**Role: XXX**` on the first line

Full methodology in [SKILL.md](SKILL.md).

## Install

### Codex / Codex Desktop (verified)

This package's `hooks-config.json` can be used directly as Codex global hooks config. The event names remain `SessionStart` and `UserPromptSubmit`.

After cloning:

```bash
git clone https://github.com/AlexPlum405/skills.git
cd skills/auto-role-router
./install.sh --target codex --dry-run
./install.sh --target codex
```

For a local checkout:

```bash
cd /Users/Alex/skills-repo/auto-role-router
./install.sh --target codex
```

Codex hook location:

```bash
~/.codex/hooks.json
```

Validate through the real execution path:

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

If you also want Codex to discover this package as a skill, sync the directory to:

```bash
~/.codex/skills/auto-role-router
```

Practical note: `codex debug prompt-input` can confirm the skill list, but may not show hook-injected context. Use `codex exec` to verify hooks actually run.

### Claude Code

> The installer backs up your current `~/.claude/settings.json` (timestamped `.backup` file) before merging hooks. Use `--dry-run` to preview changes first.

#### macOS / Linux

```bash
curl -sSL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/AlexPlum405/skills.git
cd skills/auto-role-router
./install.sh --dry-run    # preview changes
./install.sh              # apply
```

#### Windows (PowerShell)

```powershell
# Requires PowerShell 5.1+ (bundled with Windows 10/11)
irm https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.ps1 | iex
```

Or clone and run locally:

```powershell
git clone https://github.com/AlexPlum405/skills.git
cd skills\auto-role-router
.\install.ps1 -DryRun
.\install.ps1
```

### Advanced options

| Task | macOS/Linux | Windows |
|------|-------------|---------|
| Preview without writing | `./install.sh --dry-run` | `.\install.ps1 -DryRun` |
| Install to Codex | `./install.sh --target codex` | Not supported yet |
| Install to Claude Code | `./install.sh --target claude` | `.\install.ps1` |
| Clean uninstall (keeps other hooks) | `./install.sh --uninstall` | `.\install.ps1 -Uninstall` |
| Lighter "legacy" payload | `./install.sh --legacy` | `.\install.ps1 -Legacy` |

> `--legacy` uses a shorter hook payload that only *asks* the AI to declare a role — it does not force pre-activation. See [COMPARISON.md](COMPARISON.md). Not recommended for new installs.

### Uninstall

```bash
# macOS/Linux
./install.sh --uninstall

# Windows
.\install.ps1 -Uninstall
```

Uninstall is precise — it matches on `auto-role-router` inside the command string, so other hooks you installed are preserved.

## Example conversations

**Specific technical issue (narrow role):**
```
You:  My Rust async function won't compile because of lifetime issues
AI:   **Role: Rust Lifetime Expert**
      The compiler is complaining because…
```

**New technology (dynamic generation — no predefined list needed):**
```
You:  How do I configure Bun's built-in test runner?
AI:   **Role: Bun Runtime Expert**
      Bun's test runner can be configured…
```

**Domain switch:**
```
You:  How do I optimize this PostgreSQL query?
AI:   **Role: PostgreSQL Query Optimizer**
      First, let's look at the execution plan…

You:  Then how do I cache this in Redis?
AI:   **Role: Redis Caching Specialist**
      For this use case I would recommend…
```

## Compatibility

| AI Assistant | Status |
|--------------|--------|
| Claude Code (CLI / IDE plugins) | ✅ Fully tested, continuously verified in CI |
| Codex / Codex Desktop | ✅ Locally verified with `~/.codex/hooks.json` and `codex exec` triggering `SessionStart` / `UserPromptSubmit` |

> **Note:** Hook mechanisms differ across assistants (Cursor, etc.) and this repo has not verified them yet. If you test compatibility with another assistant and want to contribute install steps, PRs welcome.

## Troubleshooting

### Every turn blocks with `unexpected EOF`

A literal English apostrophe (`'`) snuck into a hook command. Inside the bash single-quoted `printf` payload, an apostrophe terminates the string. Open `~/.claude/settings.json` and rewrite `hasn't` / `don't` / `it's` / `expert's` as `has not` / `do not` / `it is` / `the ... of the expert`, then restart Claude Code.

The CI in this repo guards against this class of bug, so you only hit it if you hand-edit `settings.json`.

### AI never declares a role

1. Claude Code: `jq .hooks ~/.claude/settings.json` — confirm the hooks are actually there
2. Codex: `jq .hooks ~/.codex/hooks.json` — confirm the hooks are actually there
3. Restart the target assistant (hooks load at session start)
4. For Codex, run `codex exec ...` and confirm the logs contain `hook: SessionStart` and `hook: UserPromptSubmit`

### Role too generic

Give a more specific question:
- ❌ "How do I use Rust?" → `Rust Expert`
- ✅ "How do I fix this Rust lifetime error in my async function?" → `Rust Lifetime Expert`

## Contributing

PRs welcome for: compatibility verification with other AI assistants, smarter role construction strategies, translations. See [CONTRIBUTING.md](../CONTRIBUTING.md) in the repo root.

## License

MIT License
