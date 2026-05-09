<sub>🌐 <a href="README.en.md">English</a> · <b>中文</b></sub>

<div align="center">

# Alex 的 Claude Code 配置

> **我自己在用的 Claude Code hooks 和 skills，开源出来给有同样需求的人**

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-1-blue.svg)](#可用技能)
[![CI](https://img.shields.io/github/actions/workflow/status/AlexPlum405/skills/validate-hooks.yml?label=hooks%20CI)](https://github.com/AlexPlum405/skills/actions/workflows/validate-hooks.yml)
[![Platform](https://img.shields.io/badge/macOS%20%7C%20Linux%20%7C%20Windows-supported-lightgrey.svg)](#跨平台)

</div>

---

这是我的私人工具仓库 —— 不是一个主动维护的公开项目。代码随便用，issue 和 PR 我**可能**会看，具体见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 可用技能

### [auto-role-router](./auto-role-router)

给 Claude Code 装两条 hooks，每轮对话让 AI **先分析问题领域 → 构造最贴切的专家角色 → 以该角色生成回答**。不是事后贴标签，是回答第一个 token 就已经在专家模式。

```bash
# macOS / Linux
curl -sSL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash

# Windows
irm https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.ps1 | iex
```

详见 [auto-role-router/README.md](./auto-role-router/README.md)。

## 跨平台

所有 skill 都会在 CI 中针对以下平台跑冒烟测试：

| 平台 | 安装脚本 |
|------|---------|
| macOS | `install.sh` |
| Linux (Ubuntu) | `install.sh` |
| Windows 10/11 (PowerShell 5.1+) | `install.ps1` |

## 目录结构

```
skills/
├── README.md              # 仓库总览（中文）
├── README.en.md           # 仓库总览（英文）
├── SKILL_TEMPLATE.md      # 新 skill 模板（含 hook 编写注意事项）
├── CONTRIBUTING.md        # 如何贡献
├── .github/workflows/     # CI：JSON 验证 + hook 执行 + 三平台安装冒烟
└── skill-name/
    ├── SKILL.md
    ├── README.md
    ├── README.en.md
    ├── install.sh
    ├── install.ps1
    └── hooks-config*.json
```

## 许可证

MIT

---

<div align="center">

**Made with ❤️ by Alex**

</div>
