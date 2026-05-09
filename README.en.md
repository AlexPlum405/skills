<sub>🌐 <b>English</b> · <a href="README.md">中文</a></sub>

<div align="center">

# Alex's Claude Code Config

> **The Claude Code hooks and skills I actually use, open-sourced for anyone with the same needs**

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-1-blue.svg)](#available-skills)
[![CI](https://img.shields.io/github/actions/workflow/status/AlexPlum405/skills/validate-hooks.yml?label=hooks%20CI)](https://github.com/AlexPlum405/skills/actions/workflows/validate-hooks.yml)
[![Platform](https://img.shields.io/badge/macOS%20%7C%20Linux%20%7C%20Windows-supported-lightgrey.svg)](#cross-platform)

</div>

---

This is my personal tooling repo — not an actively maintained public project. Use the code however you like. Issues and PRs **might** get attention — see [CONTRIBUTING.md](CONTRIBUTING.md) for what to expect.

## Available Skills

### [auto-role-router](./auto-role-router)

Two Claude Code hooks that, on every turn, make the agent **analyze the question's domain → construct the most specific expert role → generate the response from that role**. Not labeling after the fact — actually in the role from the first token.

```bash
# macOS / Linux
curl -sSL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash

# Windows
irm https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.ps1 | iex
```

Details in [auto-role-router/README.en.md](./auto-role-router/README.en.md).

## Cross-platform

Every skill is smoke-tested in CI on:

| Platform | Installer |
|----------|-----------|
| macOS | `install.sh` |
| Linux (Ubuntu) | `install.sh` |
| Windows 10/11 (PowerShell 5.1+) | `install.ps1` |

## Repository structure

```
skills/
├── README.md              # Repo overview (Chinese)
├── README.en.md           # Repo overview (English)
├── SKILL_TEMPLATE.md      # Template for new skills (with hook-authoring gotchas)
├── CONTRIBUTING.md        # How to contribute
├── .github/workflows/     # CI: JSON validation + hook exec + 3-platform install smoke
└── skill-name/
    ├── SKILL.md
    ├── README.md
    ├── README.en.md
    ├── install.sh
    ├── install.ps1
    └── hooks-config*.json
```

## License

MIT

---

<div align="center">

**Made with ❤️ by Alex**

</div>
