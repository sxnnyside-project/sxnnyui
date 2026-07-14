# CLAUDE.md

Guidance for AI agents (Claude Code and equivalents) working in this repository.

## What this is

SxnnyErgo is a Swift Package of small, focused SwiftUI extensions, layouts, modifiers, and components. It carries no theme, no branding, and no application-level logic — see [README.md](README.md) for the product overview.

## Read this first

This repository is governed by a documented canon. Before making any change, start at [Documentation/REPOSITORY_CANON.md](Documentation/REPOSITORY_CANON.md) — it indexes every rule document (vision, architecture, API design, naming, public API policy, Swift standards, contributor workflow) and explains how they relate. Do not guess at conventions; they are written down.

- [Documentation/PRODUCT_DOMAINS.md](Documentation/PRODUCT_DOMAINS.md) — whether a proposed symbol belongs in this package at all
- [Documentation/API_DESIGN.md](Documentation/API_DESIGN.md) / [Documentation/NAMING.md](Documentation/NAMING.md) — shape and vocabulary for public APIs
- [Documentation/SWIFT_STANDARDS.md](Documentation/SWIFT_STANDARDS.md) — language-level correctness (concurrency, availability, modern idioms)
- [Documentation/CONTRIBUTING_ENGINEERING.md](Documentation/CONTRIBUTING_ENGINEERING.md) — the step-by-step workflow every change follows

## Standard commands

Run these instead of guessing at `swift` invocations — see the [Makefile](Makefile):

```
make build          # swift build
make test            # swift test
make format          # rewrite sources with swift-format
make format-check    # verify formatting (no writes) — what CI runs
make lint             # style diagnostics without rewriting
make dead-code        # Periphery unused-declaration scan (brew install periphery)
make check            # format-check + build + test + dead-code, in one shot
make clean            # remove build artifacts
make docs             # generate DocC documentation locally
make install-hooks    # point git at .githooks/ (commit-msg, pre-commit)
```

## Ground rules for this repo

- No product API changes without checking [Documentation/PUBLIC_API_POLICY.md](Documentation/PUBLIC_API_POLICY.md) — public surface here is a compatibility promise.
- No theming, branding, or application-level state — see [Documentation/PRODUCT_DOMAINS.md](Documentation/PRODUCT_DOMAINS.md).
- Every public symbol carries a complete DocC comment in the same commit that introduces or changes it.
- Run `make check` before considering a change done.
- Formatting is enforced by `swift-format` (bundled with the Swift 6 toolchain) via `.swift-format` at the repo root — do not hand-format or bikeshed style in review.
- Commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`) — enforced by `.githooks/commit-msg` once `make install-hooks` has been run.
- Unused declarations are flagged by Periphery (`.periphery.yml`, `make dead-code`) — `retain_public: true` is set because this is a library, so public API surface is never reported as unused, only genuinely dead internal code.
