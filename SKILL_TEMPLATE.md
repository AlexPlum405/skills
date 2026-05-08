# Skill Template

Use this template when creating new skills for this repository.

## Directory Structure

```
your-skill-name/
├── SKILL.md              # Detailed documentation (mandatory)
├── README.md             # Quick start guide (mandatory)
├── LICENSE               # License file (if different from repo)
├── CHANGELOG.md          # Version history (optional)
├── CONTRIBUTING.md       # Contribution guidelines (optional)
├── config/               # Configuration files
│   └── *.json
├── scripts/              # Installation/utility scripts
│   └── install.sh
└── examples/             # Usage examples (optional)
    └── *.md
```

## SKILL.md Template

```markdown
---
name: your-skill-name
description: >
  Brief description of what this skill does. Keep it under 200 characters.
  This description is used for skill discovery and triggering.
---

# Your Skill Name

> **One-line tagline**

## What it does

Clear explanation of the skill's purpose and functionality.

## Installation

Step-by-step installation instructions.

## Usage

How to use the skill, with examples.

## Configuration

Any configuration options available.

## Troubleshooting

Common issues and solutions.

## License

License information.
```

## README.md Template

```markdown
# Your Skill Name

> **One-line tagline**

Brief description (2-3 sentences).

## Quick Start

```bash
# Installation command
```

## Features

- ✅ Feature 1
- ✅ Feature 2
- ✅ Feature 3

## Documentation

See [SKILL.md](SKILL.md) for detailed documentation.

## License

MIT License
```

## Checklist for New Skills

Before submitting a new skill to this repository:

- [ ] Create skill directory under repository root
- [ ] Write SKILL.md with complete documentation
- [ ] Write README.md with quick start guide
- [ ] Add LICENSE file (or use repository license)
- [ ] Test installation process
- [ ] Update repository root README.md to list the new skill
- [ ] Create git commit with descriptive message
- [ ] Push to GitHub

## Naming Conventions

- **Directory name**: lowercase-with-hyphens
- **Skill name**: Same as directory name
- **Files**: UPPERCASE.md for docs, lowercase.sh for scripts

## Best Practices

1. **Documentation first**: Write docs before code
2. **Keep it simple**: One skill = one clear purpose
3. **Test thoroughly**: Verify installation on clean system
4. **Version control**: Use semantic versioning in CHANGELOG.md
5. **Cross-platform**: Test on macOS, Linux, Windows if applicable

## Example Skills

See existing skills in this repository for reference:
- [auto-role-router](./auto-role-router) - Hooks-based configuration skill
