# Contributing to SxnnyErgo

Contributions are welcome — bugs, fixes, features, or documentation.
This document covers how to work with the project as a contributor.

---

## Before You Start

- Search [existing issues](https://github.com/Sxnnyside-Project/SxnnyErgo/issues) before opening a new one.
- For significant changes, open an issue first to discuss the direction before writing code.
- Read the [Code of Conduct](CODE_OF_CONDUCT.md). It applies to all interactions in this project.
- Read [Documentation/REPOSITORY_CANON.md](Documentation/REPOSITORY_CANON.md) — this repository is governed by a documented set of engineering and product rules, and every change is evaluated against it.

---

## Development Setup

Prerequisites: Xcode 16.0+, Swift 6.0+, macOS 13.0+.

```bash
git clone https://github.com/Sxnnyside-Project/SxnnyErgo.git
cd SxnnyErgo
make build
make test
make install-hooks
```

`make install-hooks` points git at the repository's tracked hooks (`.githooks/`) — commit-message and formatting checks that run locally before CI ever sees them.

The [`Makefile`](Makefile) exposes the full standard command surface:

| Command | Does |
|---|---|
| `make build` | `swift build` |
| `make test` | `swift test` |
| `make format` | Rewrite sources with `swift-format` |
| `make format-check` | Verify formatting without writing — what CI runs |
| `make lint` | Style diagnostics without rewriting |
| `make dead-code` | Periphery unused-declaration scan (`brew install periphery`) |
| `make check` | `format-check` + `build` + `test` + `dead-code` |
| `make clean` | Remove build artifacts |
| `make docs` | Generate DocC documentation locally |

---

## Reporting a Bug

Open a [GitHub Issue](https://github.com/Sxnnyside-Project/SxnnyErgo/issues/new/choose) using the bug report template.

Include:
- What you expected to happen
- What actually happened
- Steps to reproduce
- Environment details (platform, OS version, Xcode/Swift version)

---

## Proposing a Feature

Open a [GitHub Issue](https://github.com/Sxnnyside-Project/SxnnyErgo/issues/new/choose) using the feature request template, or submit a PR directly if the change is small and self-contained.

For larger features, an issue discussion first avoids wasted effort on both sides — check [Documentation/PRODUCT_DOMAINS.md](Documentation/PRODUCT_DOMAINS.md) first to confirm the proposal belongs in SxnnyErgo at all.

---

## Workflow

1. Fork the repository and create a branch from `main`.
2. Name your branch descriptively — `fix/grid-column-width`, `feat/adaptive-badge`.
3. Make your changes, following [Documentation/API_DESIGN.md](Documentation/API_DESIGN.md), [Documentation/NAMING.md](Documentation/NAMING.md), and [Documentation/SWIFT_STANDARDS.md](Documentation/SWIFT_STANDARDS.md).
4. Run `make check` before opening the PR.
5. Open a pull request against `main` with a clear description of what changed and why.

---

## Pull Request Checklist

Before submitting:

- [ ] `make check` passes (formatting, build, tests, dead-code)
- [ ] Changes are described in [CHANGELOG.md](CHANGELOG.md) under `[Unreleased]`
- [ ] The PR description explains what changed and why
- [ ] New or modified public symbols carry a complete DocC comment
- [ ] New behavior is covered by tests

---

## Commit Style

This project uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), enforced locally by the `commit-msg` hook once `make install-hooks` has been run. Every commit message must follow the format:

```
<type>: <description>

[optional body]
[optional footer]
```

Accepted types:

| Type       | Use for                                          |
|------------|---------------------------------------------------|
| `feat`     | New functionality                                |
| `fix`      | Bug fixes                                        |
| `docs`     | Documentation only                               |
| `style`    | Formatting, whitespace — no logic changes        |
| `refactor` | Code restructure without behavior change         |
| `test`     | Adding or updating tests                         |
| `chore`    | Build process, tooling, dependencies             |
| `perf`     | Performance improvements                         |

Examples:

```
feat: add IconButton press-state animation
fix: prevent BreakpointLayout crash on zero-width containers
docs: correct installation steps for Xcode 16
chore: add Periphery dead-code scan to CI
```

Commits that don't follow this format are rejected by the hook and flagged during review.

---

## Questions

If something in the codebase is unclear, open an issue with the `question` label before assuming it's a bug.

---

*SxnnyErgo is a Sxnnyside Project. Part of the [Sxnnyside Project](https://sxnnysideproject.com).*
