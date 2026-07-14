# Contributing — Engineering Expectations

> Normative. Governs how any change to source code is proposed, reviewed, and accepted. Complements [CONTRIBUTING.md](../CONTRIBUTING.md) (process/community) with the engineering bar every change must clear.
> Authority: [VISION.md](VISION.md) §12 ("High Contributor Ergonomics").

This document exists so every contributor works from one consistent basis for what pattern to follow. [REPOSITORY_CANON.md](REPOSITORY_CANON.md) is the entry point; this document is what a contributor reads before opening a pull request.

---

## 1. Engineering Workflow

1. **Before writing code**, confirm the change fits a domain in [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md). If it doesn't, the correct next step is to open an issue proposing scope, not to write the code first.
2. **Design the public surface first.** Write the intended public declaration (signature, doc comment) before the implementation, and check it against [API_DESIGN.md](API_DESIGN.md) and [NAMING.md](NAMING.md) before investing in the body.
3. **Implement**, following [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) and placing files per [ARCHITECTURE.md](ARCHITECTURE.md).
4. **Test** per §5 below, before opening the PR — not as a follow-up commit requested in review.
5. **Document** per §4 below, in the same PR as the implementation.
6. **Open the PR** using the template, filling out the API review checklist (§6) inline.

## 2. Review Expectations

- Every PR touching a public symbol requires review against every applicable canon document, not just a general code-quality read. A reviewer approving a PR is asserting the change complies with [API_DESIGN.md](API_DESIGN.md), [NAMING.md](NAMING.md), [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md), [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md), and [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) as applicable.
- A reviewer who finds a canon violation blocks the PR and cites the specific document/section, not a general stylistic objection. Citing the document turns a subjective disagreement into an objective, checkable rule — this is the entire point of Epic 0.
- A PR introducing a new pattern not covered by existing canon (a new configuration mechanism, a new naming category) does not merge silently. The pattern is either matched to an existing rule, or the canon documents are updated first (deliberately, as their own change) before the pattern is used in product code. Canon changes are rare by design (see [REPOSITORY_CANON.md](REPOSITORY_CANON.md) on stability) — most PRs should find their answer already written down.
- No self-approval on a PR that adds or changes public API.

## 3. Acceptance Criteria

A PR is acceptable to merge only when:

- [ ] It changes exactly one coherent thing (one symbol, one bug fix, one refactor) — not a bundle of unrelated changes.
- [ ] It does not introduce a symbol outside the six domains in [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md).
- [ ] Every new/changed public declaration satisfies [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §1 in full.
- [ ] It does not reintroduce any anti-pattern listed in [NAMING.md](NAMING.md)'s Anti-Pattern Reference.
- [ ] It builds with zero warnings under the strictest compiler settings the package enables, on every platform the touched code claims to support.
- [ ] It includes tests satisfying [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §3 for anything public, or [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md)-level tests for internal logic complex enough to warrant them.
- [ ] It does not add a third-party dependency (see [PACKAGE_MODEL.md](PACKAGE_MODEL.md) §5) without a separate, explicit prior decision to do so.

## 4. Documentation Expectations

- Every public symbol added or modified carries a complete DocC comment per [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §4 in the same commit as the code.
- CHANGELOG.md is updated in the same PR as any public-facing change, using strict SemVer language ("Added", "Changed", "Deprecated", "Removed", "Fixed") — no vague entries like "minor fixes."
- If a PR changes a canon document (rare — see §2), the PR description states which document changed and why, separately from any code change in the same area. Canon changes are not bundled invisibly inside unrelated feature PRs.

## 5. Testing Expectations

- New public API: tests required per [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §3, written before the PR is opened for review.
- Bug fixes: a regression test reproducing the bug is added in the same PR as the fix, and is verified to fail against the pre-fix code.
- Refactors with no behavior change: existing tests must pass unmodified; if a refactor requires changing a test's assertions, that is a signal the "refactor" changed behavior and needs to be reclassified and reviewed accordingly.
- No PR decreases overall test coverage. A PR that deletes tested code removes the corresponding tests in the same PR, not as orphaned dead assertions.

## 6. API Review Checklist

Attach this to every PR touching public API (mirrors [API_DESIGN.md](API_DESIGN.md)'s summary checklist, extended with process items):

- [ ] Domain fit confirmed ([PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md))
- [ ] Naming checked against [NAMING.md](NAMING.md), including the Anti-Pattern Reference
- [ ] Parameter labels/ordering consistent with any sibling overload
- [ ] No `AnyView`, no `precondition`/`fatalError` for caller-triggerable conditions
- [ ] Defaults reviewed: sensible, overridable, no hardcoded locale/brand value
- [ ] `@MainActor`/`Sendable`/`Observable` usage justified per [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) §3–5
- [ ] Availability annotations verified against `Package.swift` minimums
- [ ] DocC comment complete with usage example
- [ ] Tests present and passing on every platform claimed
- [ ] Five-year evolution question ([API_DESIGN.md](API_DESIGN.md) §14) answered in the PR description
- [ ] CHANGELOG.md updated with SemVer-correct entry

## 7. Pull Request Checklist

General hygiene, applies to every PR regardless of whether it touches public API:

- [ ] PR title and description explain *why*, not just *what* (the diff already shows what)
- [ ] Scope is one coherent change
- [ ] CI passes on every declared platform
- [ ] No unrelated formatting/whitespace churn bundled into a functional change
- [ ] No new file placed outside the folder structure defined in [ARCHITECTURE.md](ARCHITECTURE.md) §1
- [ ] No planning/notes/scratch files committed to the repository (per [REPOSITORY_CANON.md](REPOSITORY_CANON.md), internal planning documents do not live in the source tree long-term)
