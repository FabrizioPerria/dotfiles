# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## 5. Role Collection

Voltagent subagent marketplace lives at:
`~/.claude/plugins/marketplaces/voltagent-subagents/categories/`

Categories:
- `01-core-development/` — frontend, backend, fullstack, API
- `02-language-specialists/` — python-pro, typescript-pro, rust, go, etc.
- `03-infrastructure/` — devops, docker, k8s, terraform
- `04-quality-security/` — code-reviewer, qa-expert, security-auditor
- `05-data-ai/` — ml-engineer, data-scientist, llm-architect
- `06-developer-experience/` — git-workflow-manager, cli-developer, refactoring
- `07-specialized-domains/` — fintech, embedded, game-dev
- `08-business-product/` — product-manager, technical-writer
- `09-meta-orchestration/` — workflow-orchestrator, multi-agent-coordinator
- `10-research-analysis/` — research-analyst, data-researcher

When asked to "find a role" or "look for agents in the collection", read relevant `.md` files from this path.

## 6. Agentic Workflow Scaffolding

`~/.claude/run-agents.py` is the generic tmux-based workflow runner (preferred). `~/.claude/run-agents.sh` is the bash equivalent (kept for reference). Both read `workflow.json` from the project directory and orchestrate one Claude TUI pane per role.

### Named workflows

**swarm** = the pm → arch → dev → qa → devops pipeline scaffolded via `run-agents.py`.
- Trigger words: "swarm", "run swarm", "swarm it", "launch swarm".
- When user says "agentic workflow" without naming it, ask: "Do you mean swarm or a different workflow?"

### Running swarm (or any workflow)

When asked to run the workflow:
1. `cd` into the project directory.
2. Run `./run-agents.py "feature description"` directly — that's it.
3. **Do NOT**: create tmux sessions, run `tmux new-session`, check `tmux ls`, or issue any tmux commands. Assume tmux is already running.

### When to trigger scaffolding
User says anything like: "set up agentic workflow", "scaffold agents for this project", "use the workflow with these roles", "run agents for X".

### How to scaffold a project

1. Read the relevant role `.md` files from the role collection (section 5 above).
2. Generate `workflow.json` in the project root — schema below.
3. Create `.claude/agents/<role>-agent.md` for each role — adapt the role collection prompt to the project's tech stack and file ownership.
4. Copy `~/.claude/run-agents.py` into the project root.

Do NOT create static template copies. Always pull fresh from the role collection and adapt.

### `workflow.json` schema

```json
{
  "roles": [
    {
      "name": "short-id",
      "prompt": "Use <name>-agent to ... ${FEATURE}",
      "wait-for": ["other-role"],
      "talks-to": ["other-role"],
      "approve-signal": "APPROVED",
      "reject-prompt": "Changes requested. Fix the code.",
      "max-rounds": 3
    }
  ]
}
```

| Field | Required | Description |
|---|---|---|
| `name` | yes | Short role ID, unique, kebab-case |
| `prompt` | yes | Sent to the pane. Use `${FEATURE}` for runtime substitution |
| `wait-for` | no | Array of role names that must finish first |
| `talks-to` | no | Array of roles the reviewer sends feedback to on rejection |
| `approve-signal` | no | String to grep for in pane output — triggers approval |
| `reject-prompt` | no | Prompt sent to `talks-to` roles on rejection |
| `max-rounds` | no | Max review iterations (default 1) |

### Standard role pipeline pattern

```
pm → arch → [dev, frontend, devops] → qa → se ⟲ dev
```

- `pm`: feature → `TODO.md`. No code.
- `arch`: interfaces, routes, contracts → `ARCHITECTURE.md`. No code.
- dev roles: implement, each owns a distinct file subtree (no overlap).
- `qa`: tests only, no production code.
- `se`: review loop. `approve-signal: "APPROVED"`, `talks-to` dev roles, `max-rounds: 3`.

### Agent file rules

Each `.claude/agents/<name>-agent.md` must have frontmatter:

```markdown
---
name: <name>-agent
description: One-line summary.
tools: Read, Write, Edit, Bash
---

System prompt...
```

Key constraints to encode per agent:
- What files it **owns** (writes to)
- What files it **reads** (from prior agents)
- What it must **not** do (e.g. pm: no code, qa: no production changes, se: no code changes)
- What its **output signal** is (se must end with APPROVED or CHANGES REQUESTED)

### Running

```bash
cd <project>
./run-agents.py "feature description"
```

Opens tmux window named after the project directory. `${FEATURE}` in prompts is replaced with the argument.

### Language Conventions

When generating agent files for a project, enforce these per-language rules in every relevant agent prompt (dev, qa, devops, se).

#### Python
- **DO**: `python3 -m venv .venv` + `source .venv/bin/activate` before any pip command; use `uv` if available; `ruff` for lint+format; `mypy` for types; `pytest` for tests; pin deps in `pyproject.toml`; commit lock file
- **DON'T**: never `pip install --break-system-packages`; never install to system Python; never mix venv + conda

#### Go
- **DO**: `go mod tidy` before commit; `golangci-lint` via `.golangci.yml`; `gofmt`/`goimports` before commit; `go test ./...` in CI; Makefile with `fmt`, `lint`, `test`, `build` targets
- **DON'T**: never GOPATH hacks; never manually edit `go.sum`; never skip `go mod tidy` in CI

#### TypeScript / Node.js
- **DO**: `npm ci` in CI (never `npm install`); commit `package-lock.json`; `"strict": true` in tsconfig; `eslint` + `prettier`; use `Corepack` to pin package manager version
- **DON'T**: never `npm install -g`; never commit `node_modules`; never disable strict mode; never mix npm + yarn + pnpm

#### Java
- **DO**: always use `mvnw` or `gradlew` wrappers (never rely on global install); JUnit 5; Checkstyle + SpotBugs in CI; try-with-resources for I/O; centralise dep versions in `pom.xml`/`build.gradle`
- **DON'T**: never run `javac` directly; never commit `*.class`, `target/`, or `build/`

#### Kotlin
- **DO**: Gradle + `gradlew` wrapper (preferred); if `pom.xml` present, use `mvnw` or `mvn compile`; `detekt` + `ktlint` in CI; Kotlin stdlib collections (`listOf`, `mapOf`); structured coroutine scopes (`lifecycleScope`, `viewModelScope`)
- **DON'T**: never raw Java collections when Kotlin stdlib exists; never `GlobalScope` for coroutines; never skip detekt

#### C / C++
- **DO**: CMake with out-of-source build (`mkdir build && cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`); committed `.clang-format`; AddressSanitizer in test builds (`-fsanitize=address`)
- **DON'T**: never hardcode compiler flags in source; never run `g++`/`clang++` directly; never commit `build/`, `*.o`, `*.a`

#### C# / .NET
- **DO**: `dotnet` CLI only (`dotnet build`, `dotnet test`, `dotnet format`); `<Nullable>enable</Nullable>` in `.csproj`; xUnit for tests; NuGet via `dotnet add package`
- **DON'T**: never call `csc.exe` directly; never suppress nullable warnings without `#pragma` + comment; never disable nullable to hide warnings

#### Bash
- **DO**: `#!/usr/bin/env bash` + `set -euo pipefail`; quote all variables `"$var"`; use `[[ ]]` not `[ ]`; run `shellcheck`; use `"$@"` not `$*`
- **DON'T**: never parse `ls`; never use `eval`; never use aliases in scripts; never ignore shellcheck warnings

#### Zig
- **DO**: `zig build` via `build.zig`; `zig test` with `std.testing.allocator`; `zig fmt` before commit; pass allocators as parameters explicitly
- **DON'T**: never assume global allocator; never mix with CMake/Makefile; never skip allocator strategy

#### PowerShell
- **DO**: `Set-StrictMode -Version Latest`; `#Requires` for deps; approved verbs (`Get-`, `Set-`, `New-`, `Remove-`); `PSScriptAnalyzer`; `$ErrorActionPreference = 'Stop'`
- **DON'T**: never use aliases in scripts (`gwmi` → `Get-WmiObject`); never `Write-Host` (return objects); never omit error handling

#### Lua
- **DO**: declare all variables `local`; `stylua` for formatting; `luacheck` for linting; `luarocks` for packages; explicit `.close()` for resources
- **DON'T**: never create globals; never rely on `__gc` for cleanup; never use tabs (stylua enforces spaces)
