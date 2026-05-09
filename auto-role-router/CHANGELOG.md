# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-05-09

### Fixed
- Hook commands crashed with `unexpected EOF while looking for matching "'"` because English apostrophes inside the bash single-quoted payload (e.g. `hasn't`, `don't`, `expert's`) terminated the quoted string early. Rewritten without apostrophes; verified with `bash -c` execution of all three hook commands.

## [1.0.0] - 2026-05-08

### Added
- Initial release of auto-role-router skill
- Automatic domain identification and expert role assignment
- Support for both English and Chinese role declarations
- Cross-platform compatibility (Claude Code, Cursor, Codex, OpenClaw, etc.)
- Hook-based auto-activation option
- Comprehensive documentation in both English and Chinese

### Features
- Specific role granularity (e.g., "Rust Macro Expert" vs. generic "Developer")
- Role persistence across related questions in the same domain
- Temporary disable option for specific turns
- Language-aware role formatting

[1.0.0]: https://github.com/AlexPlum405/skills/releases/tag/v1.0.0
