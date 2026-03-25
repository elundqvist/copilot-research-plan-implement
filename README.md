# Claude Research-Plan-Implement Framework (Archived)

This repo is no longer maintained. The original commands and agents were inspired by [HumanLayer's](https://github.com/humanlayer/humanlayer/) `.claude/` setup, simplified and tailored with Claude Code to specific workflows.

The work has since evolved into a plugin-based skill system that we use daily:

| Repo | What it does |
|------|-------------|
| [teambrilliant/dev-skills](https://github.com/teambrilliant/dev-skills) | Development workflow skills — shape, plan, implement, QA |
| [teambrilliant/tap-skills](https://github.com/teambrilliant/tap-skills) | Team autonomy methodology for human+agent teams |
| [teambrilliant/marketplace](https://github.com/teambrilliant/marketplace) | Plugin registry for discovering and installing skills |

## Quick start with the new skills

```bash
/plugin marketplace add teambrilliant/marketplace
/plugin install dev-skills@teambrilliant
/plugin install tap-skills@teambrilliant
```
