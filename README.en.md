<sub>🌐 <b>English</b> · <a href="README.md">中文</a></sub>

<div align="center">

# Alex's Skills Collection

> **Custom skills and configurations for AI coding assistants**

[![GitHub Stars](https://img.shields.io/github/stars/AlexPlum405/skills?style=social)](https://github.com/AlexPlum405/skills/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/AlexPlum405/skills?style=social)](https://github.com/AlexPlum405/skills/network/members)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills Count](https://img.shields.io/badge/Skills-1-blue.svg)](#available-skills)
[![Agent Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet)](https://skills.sh)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

This repository contains custom skills and configurations I built for AI coding assistants like Claude Code, Cursor, and others. Each skill lives in its own directory with dedicated docs and one-command installation.

## Available Skills

### [auto-role-router](./auto-role-router)

Automatically assigns expert roles to your AI assistant based on question domain. Uses **dynamic role generation** to work with any technology stack — including frameworks that don't exist yet.

**Features:**
- ✅ Dynamic role generation (no fixed role library to maintain)
- ✅ Two versions: Basic and Pre-activation mode (Plan A)
- ✅ Cross-platform compatible
- ✅ Future-proof (adapts to new technologies automatically)

**Quick install:**
```bash
curl -sL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash
```

See [auto-role-router/README.md](./auto-role-router/README.md) for details.

---

## Repository Structure

```
skills/
├── README.md              # Repo overview (Chinese)
├── README.en.md           # Repo overview (English)
├── SKILL_TEMPLATE.md      # Template for new skills
└── skill-name/            # One directory per skill
    ├── SKILL.md           # Detailed documentation
    ├── README.md          # Quick start (Chinese)
    ├── README.en.md       # Quick start (English)
    ├── install.sh         # Installation script
    └── ...
```

## Contributing

This is a personal collection, but suggestions and improvements are welcome. If you'd like to add a new skill, refer to [SKILL_TEMPLATE.md](./SKILL_TEMPLATE.md).

## License

Each skill may have its own license — check individual subdirectories. The repository as a whole uses MIT.

---

<div align="center">

**Made with ❤️ by Alex**

</div>
