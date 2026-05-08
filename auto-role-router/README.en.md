<sub>🌐 <b>English</b> · <a href="README.md">中文</a></sub>

<div align="center">

# Auto Role Router

> **Hooks configuration for automatic expert role assignment in AI coding assistants**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet)](https://skills.sh)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](CHANGELOG.md)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)](#compatibility)

[Features](#why-use-it) • [Installation](#installation) • [Documentation](SKILL.md) • [Comparison](COMPARISON.md)

</div>

---

## What is this

A hooks configuration package that makes your AI assistant automatically identify its expert role for each question and display it at the start of every response.

**Not a callable skill** — This is a documentation and configuration package. Install once, works automatically.

**Example:**

```
User: How do I fix this Rust lifetime error?
AI: **Role: Rust Lifetime Expert**

The issue here is...
```

```
User: How do I optimize this SQL query?
AI: **Role: Database Performance Specialist**

First, check the execution plan...
```

## Why use it

- ✅ **Better context** — AI tailors responses to specific domains
- ✅ **Consistency** — Maintains the same role across related questions
- ✅ **Transparency** — Always know what perspective the AI is answering from
- ✅ **Future-proof** — Uses dynamic role generation, works with any tech stack
- ✅ **Cross-platform** — Works with Claude Code, Cursor, and other AI assistants

## Key Feature: Dynamic Role Generation

Unlike traditional approaches with fixed role libraries, auto-role-router uses **dynamic role generation**:

- ✅ Works with **any technology**, including frameworks that don't exist yet
- ✅ No coverage gaps — if you can name it, the AI can role-play it
- ✅ Automatically adjusts granularity based on question specificity

**Examples of dynamically generated roles:**
- New runtime? → `Bun Runtime Expert`
- Specific issue? → `Rust Lifetime Expert`
- Broad question? → `Rust Expert`

## Installation

### Two versions available

- **Basic version (recommended)** — Simple role declaration
- **Plan A version (advanced)** — Pre-activation mode for better first-response quality

See [COMPARISON.md](COMPARISON.md) for detailed comparison.

### Method 1: Quick install (Basic version)

```bash
# Backup your settings
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# One-command install (requires curl and jq)
curl -sL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash
```

### Method 2: Install Plan A version

```bash
# Backup your settings
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# Clone repo
git clone https://github.com/AlexPlum405/skills.git
cd skills/auto-role-router

# Merge Plan A hooks
jq -s '.[0] * .[1]' ~/.claude/settings.json hooks-config-plan-a.json > ~/.claude/settings.json.tmp
mv ~/.claude/settings.json.tmp ~/.claude/settings.json

echo "✅ Installed! Restart Claude Code to activate."
```

### Method 3: Manual installation

1. **Clone this repo:**
   ```bash
   git clone https://github.com/AlexPlum405/skills.git
   cd skills/auto-role-router
   ```

2. **Choose your version:**
   - Basic: `hooks-config.json`
   - Plan A: `hooks-config-plan-a.json`

3. **Copy hooks configuration:** Open `~/.claude/settings.json` and merge the content from your chosen config file.

4. **Restart your AI assistant:** Restart Claude Code (or your AI assistant) for hooks to take effect.

Full installation guide: See [SKILL.md](SKILL.md) for detailed instructions.

## How it works

Auto-role-router injects hooks into your AI assistant that execute before each response:

1. **Extract keywords** from the question (tech stack, framework, tool)
2. **Determine granularity** (specific issue → narrow role, broad question → general role)
3. **Construct role name** using formula: `[Tech] + [Specialization] + Expert/Specialist`
4. **Declare on first line** in the appropriate language

See [SKILL.md](SKILL.md) for detailed methodology.

## Example Conversations

**Specific technical issue:**
```
User: Why is my Rust async function not compiling due to lifetime issues?
AI: **Role: Rust Lifetime Expert**

The compiler is complaining because...
```

**New technology (not in any predefined list):**
```
User: How do I configure Bun's built-in test runner?
AI: **Role: Bun Runtime Expert**

Bun's test runner can be configured...
```

**Domain switch:**
```
User: How do I optimize this PostgreSQL query?
AI: **Role: PostgreSQL Query Optimizer**

First, let's examine the execution plan...

User: Now how do I cache this result in Redis?
AI: **Role: Redis Caching Specialist**

For this use case, I recommend...
```

## Compatibility

| AI Assistant | Status | Notes |
|--------------|--------|-------|
| Claude Code | ✅ Tested | Fully tested with hooks |
| Cursor | ⚠️ Theoretical | Should work if hooks are supported |
| Other assistants | ⚠️ Varies | Check if your assistant supports hooks |

## Troubleshooting

### AI not declaring roles

1. Check hooks installation: `cat ~/.claude/settings.json | grep "auto-role-router"`
2. Restart your AI assistant
3. Verify JSON syntax: `jq . ~/.claude/settings.json`

### Roles too generic

Provide more specific details in your question:
- ❌ "How do I use Rust?"
- ✅ "How do I fix this Rust lifetime error in my async function?"

## Uninstallation

1. Open `~/.claude/settings.json`
2. Remove the `SessionStart` and `UserPromptSubmit` hooks related to auto-role-router
3. Restart your AI assistant

## Contributing

Contributions welcome:
- Installation scripts for other AI assistants
- Improved role construction logic
- Additional language support
- Better examples

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

MIT License — Free to use, modify, and distribute.

---

<div align="center">

**Made with ❤️ for better AI-human collaboration**

</div>
