<sub>🌐 <a href="README.en.md">English</a> · <b>中文</b></sub>

<div align="center">

# Alex 的技能合集

> **AI 编程助手的自定义技能与配置**

[![GitHub Stars](https://img.shields.io/github/stars/AlexPlum405/skills?style=social)](https://github.com/AlexPlum405/skills/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/AlexPlum405/skills?style=social)](https://github.com/AlexPlum405/skills/network/members)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Skills Count](https://img.shields.io/badge/Skills-1-blue.svg)](#可用技能)
[![Agent Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet)](https://skills.sh)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

这个仓库收录我为 Claude Code、Cursor 等 AI 编程助手打造的自定义技能和配置。每个 skill 独立目录、独立文档、一键安装。

## 可用技能

### [auto-role-router](./auto-role-router)

根据问题领域自动为 AI 助手分配专家角色。使用**动态角色生成**，适用于任何技术栈——包括尚不存在的新框架。

**特性：**
- ✅ 动态角色生成（无需维护角色库）
- ✅ 两个版本：基础版 + 预激活模式（方案 A）
- ✅ 跨平台兼容
- ✅ 面向未来（自动适配新技术）

**快速安装：**
```bash
curl -sL https://raw.githubusercontent.com/AlexPlum405/skills/main/auto-role-router/install.sh | bash
```

详见 [auto-role-router/README.md](./auto-role-router/README.md)。

---

## 目录结构

每个 skill 独立一个子目录：

```
skills/
├── README.md              # 仓库总览（中文）
├── README.en.md           # 仓库总览（英文）
├── SKILL_TEMPLATE.md      # 新 skill 模板
└── skill-name/            # 每个 skill 一个目录
    ├── SKILL.md           # 详细文档
    ├── README.md          # 快速入门
    ├── install.sh         # 安装脚本
    └── ...
```

## 贡献

这是个人合集，但欢迎建议和改进。如果你想添加新 skill，可以参考 [SKILL_TEMPLATE.md](./SKILL_TEMPLATE.md)。

## 许可证

每个 skill 可能有自己的许可证，详见各子目录。仓库整体使用 MIT。

---

<div align="center">

**Made with ❤️ by Alex**

</div>
