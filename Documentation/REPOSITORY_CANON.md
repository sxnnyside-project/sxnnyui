# Repository Canon

> **Read this first.** This is the entry point for every contributor, before touching any code.

SxnnyErgo is governed by a set of foundational documents produced in Epic 0 ("Foundation"). Together they form the project's constitution: the *why* lives in [VISION.md](VISION.md); the *how* lives in the documents indexed below. Every future pull request is evaluated against these documents.

**These documents are meant to be stable.** If a component doesn't fit [API_DESIGN.md](API_DESIGN.md), the default assumption is that the component is wrong, not that the document needs to change. Canon changes are rare, deliberate, and never bundled silently into a feature PR — see [CONTRIBUTING_ENGINEERING.md](CONTRIBUTING_ENGINEERING.md) §2. The intent is that the foundation survives intact for the life of the project, and that change happens in the code, not in the rules.

---

## The Canon Set

| Document | Answers |
|---|---|
| [API_DESIGN.md](API_DESIGN.md) | How should every future public API be designed? |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Where does code live, and in what direction do dependencies flow? |
| [NAMING.md](NAMING.md) | What is every identifier called, and why? |
| [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) | What is SxnnyErgo allowed to contain? |
| [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) | When can something become public, and how are public promises kept or broken? |
| [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) | What does correct, modern Swift look like in this codebase? |
| [PACKAGE_MODEL.md](PACKAGE_MODEL.md) | What is the long-term shape of the package, and when does it change? |
| [CONTRIBUTING_ENGINEERING.md](CONTRIBUTING_ENGINEERING.md) | What does a contributor actually do, step by step? |

## How the Documents Relate

```
VISION.md ──────────────────────────► PRODUCT_DOMAINS.md ──► what may exist
                                       │
                                       ▼
                              API_DESIGN.md ◄────► NAMING.md
                                       │        (shape)   (identifiers)
                                       ▼
                          PUBLIC_API_POLICY.md ──► when it may ship, how it evolves
                                       │
                                       ▼
                            SWIFT_STANDARDS.md ──► language-level correctness
                                       │
                                       ▼
                             ARCHITECTURE.md ◄──► PACKAGE_MODEL.md
                          (where code lives now)  (where targets go later)
                                       │
                                       ▼
                       CONTRIBUTING_ENGINEERING.md ──► the workflow that enforces all of the above
```

- **PRODUCT_DOMAINS.md** is upstream of everything else: a symbol must belong to a domain before any question of shape, naming, or eligibility applies.
- **API_DESIGN.md** and **NAMING.md** define shape and vocabulary together — a symbol that is well-named but badly shaped, or well-shaped but badly named, is still not compliant.
- **PUBLIC_API_POLICY.md** is the gate between "shaped correctly" and "allowed to ship" — it owns testing, documentation, and compatibility commitments.
- **SWIFT_STANDARDS.md** is orthogonal to product scope — it governs correctness at the language level regardless of which domain a symbol lives in.
- **ARCHITECTURE.md** governs today's single-target layout; **PACKAGE_MODEL.md** governs the destination if/when that layout needs to split. Architecture never changes speculatively to chase the package model — the model only pulls the architecture forward when its own stated triggers are met.
- **CONTRIBUTING_ENGINEERING.md** is the only document written as a workflow rather than a rule set — it is the checklist form of everything above it.

## What Governs What: Quick Lookup

| If you're deciding... | Consult |
|---|---|
| "Does this belong in SxnnyErgo at all?" | [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) |
| "What do I name this type/function/file?" | [NAMING.md](NAMING.md) |
| "How should this initializer/modifier/builder be shaped?" | [API_DESIGN.md](API_DESIGN.md) |
| "Can I mark this `public` yet?" | [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) |
| "Should this be `@MainActor`/`Sendable`/`@Observable`?" | [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) |
| "What folder does this file go in?" | [ARCHITECTURE.md](ARCHITECTURE.md) |
| "Should this become its own target/product?" | [PACKAGE_MODEL.md](PACKAGE_MODEL.md) |
| "What does my PR need before it's mergeable?" | [CONTRIBUTING_ENGINEERING.md](CONTRIBUTING_ENGINEERING.md) |

## Non-Negotiable Rules

The five patterns every contributor should know without needing to look them up:

1. **No blanket `Sxnny` prefix, and no renamed wrapper around a native SwiftUI type with unchanged behavior.** ([NAMING.md](NAMING.md) §3, [API_DESIGN.md](API_DESIGN.md) §1)
2. **No `precondition`/`fatalError` for a condition a caller can trigger with valid, well-typed input.** ([API_DESIGN.md](API_DESIGN.md) §4, [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) §12)
3. **No hardcoded, non-overridable global state (theme colors, locale-specific strings) in a public component.** ([API_DESIGN.md](API_DESIGN.md) §11, [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §2)
4. **No infrastructure (logging, keychain, alerting) or domain-specific data models in this package, ever.** ([PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md), "What This Library Does Not Contain")
5. **No public symbol ships without tests and DocC documentation.** ([PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §3–4)

## Scope of Epic 0

This canon was produced without modifying any source file, redesigning any API, adding or removing any component, or proposing a roadmap. It defines *how* future decisions are made. What those decisions actually change — bringing the existing surface into compliance — is refactoring work reserved for later epics, evaluated against this canon once it exists.
