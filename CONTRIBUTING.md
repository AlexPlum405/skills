# Contributing

这是我个人用的 Claude Code 配置，开源出来是方便有同样需求的人直接装，**不是一个主动维护的公开项目**。所以：

- **Issue**：可以开，但我不保证回复。写得清楚、能复现的我更可能看。
- **PR**：欢迎提，但我只会合对我自己有用的改动。想贡献大功能前建议先开 issue 确认方向。
- **功能请求**：如果不是"你自己打算实现并交付"，大概率会被关闭。

This is the Claude Code config I personally use, open-sourced so others with the same needs can install it directly. **It is not an actively maintained public project.** So:

- **Issues**: Feel free to open, but I do not promise to reply. Clear, reproducible reports have a much better chance.
- **PRs**: Welcome, but I will only merge changes useful to me. For large features, please open an issue first to confirm direction.
- **Feature requests**: If you are not planning to implement and ship it yourself, it will likely be closed.

---

## 如果你要提 PR — Quality bar

每个 skill 在仓库里都要达到：

- `SKILL.md` + `README.md` + `README.en.md`
- 修改 `settings.json` 的 skill 要有 `install.sh` + `install.ps1`，都带 `--dry-run` 和 `--uninstall`
- `.github/workflows/` 里有对应 CI，必须本地跑过能过
- hook JSON payload 里不能有英文撇号（`'`）—— 详见 [SKILL_TEMPLATE.md](SKILL_TEMPLATE.md#hook-authoring-gotchas)

Every skill in this repo must meet:

- `SKILL.md` + `README.md` + `README.en.md`
- Skills that modify `settings.json` need both `install.sh` and `install.ps1`, each with `--dry-run` and `--uninstall`
- Matching CI in `.github/workflows/`, must pass locally before PR
- No English apostrophes (`'`) in any hook JSON payload — see [SKILL_TEMPLATE.md](SKILL_TEMPLATE.md#hook-authoring-gotchas)

## PR checklist

- [ ] `install.sh --dry-run` 和 `install.ps1 -DryRun` 还能跑
- [ ] hook JSON 里没有英文撇号
- [ ] CI 绿了
- [ ] 行为变化已同步到文档
- [ ] 对应 skill 的 `CHANGELOG.md` 更新了

## License

MIT. Use it however you want.
