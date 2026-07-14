# Architecture

> Normative. Defines the intended structural model of the repository — where code lives and why.
> Authority: [VISION.md](VISION.md) §7.

This document defines the target architecture. It does **not** direct any reorganization — folder moves, target splits, or file relocation are refactoring work scoped to a later epic. This document exists so that when that epic happens, every contributor is moving toward the same destination instead of improvising one.

---

## 1. Folder Organization

The repository organizes source by **product domain**, not by Swift language construct. A folder answers "what is this for," not "what kind of declaration is this."

Canonical top-level layout under `Sources/SxnnyErgo/`:

```
Sources/SxnnyErgo/
  Modifiers/          — View-modifier extensions (Domain 1)
  Bindings/            — Binding<T> extensions (Domain 2)
  Collections/          — Collection/Array/Optional extensions (Domain 3)
  Color/               — Color & Shape extensions (Domain 4)
  Strings/             — String/StringProtocol extensions (Domain 5)
  Platform/            — Platform adaptation utilities (Domain 6)
```

Each folder maps 1:1 to exactly one domain defined in [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md). A folder never mixes two domains, and a domain never spreads across two top-level folders. A former `Manager/` folder mixed `AlertManager` (UI state) with `KeychainManager` (Security/Foundation), and a former `Utilities/` folder mixed `Logger`, formatters, and unrelated domain models with no shared identity — this rule exists to prevent both.

Rules:

- **No folder name may contain a space, non-ASCII character, or punctuation other than a hyphen.** `Layout/Dimensional Z/` is the counterexample and is explicitly disallowed going forward.
- **No folder groups content by "misc," "utilities," "helpers," or "struct data."** These are not domains; they are an admission that the content inside was never scoped. `StructData/`, as a folder name and as a concept, does not exist in the target architecture.
- Folder depth does not exceed two levels below `Sources/SxnnyErgo/` (domain, then an optional sub-category within that domain, e.g. a `Modifiers/Visibility/` grouping if a domain grows large enough to need it). Depth exists to aid navigation, not to encode taxonomy no one will maintain.

## 2. Domain Ownership

Each of the six product domains in [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) owns exactly one folder (§1). A symbol's folder placement is fully determined by which domain it belongs to — there is no case where a symbol's folder is a judgment call independent of its domain classification. If a proposed symbol does not clearly belong to one domain, it does not ship (see [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) §Inclusion Criteria) — a new folder is never created to accommodate a symbol that doesn't fit an existing domain; that is a signal the symbol is out of scope, not a signal the taxonomy needs to grow.

## 3. Dependency Direction

- All domains depend only on `SwiftUI`, `Swift` standard library, and — where unavoidable — `Foundation`. No domain depends on another domain's internal (non-public) types.
- Cross-domain dependency is permitted only through public API. A `Modifiers/` symbol may call a public `Bindings/` symbol; it may not reach into an internal implementation type in `Bindings/`.
- Dependency flows outward from primitives to composites, never the reverse: `Collections/` and `Strings/` (pure extensions on standard library types) have zero dependency on `Modifiers/` or `Platform/`. `Platform/` may depend on `Modifiers/` (a platform-adaptive layout is expressed as a modifier), but `Modifiers/` never depends on `Platform/`.
- No domain imports `UIKit`/`AppKit` directly in its public surface. Platform-bridging code is isolated behind `#if canImport(UIKit)` internal to a single file within `Platform/`, never leaked into a domain's public type signatures without a platform-neutral abstraction over it.

## 4. Internal Boundaries

- Every file's declarations default to `internal` unless promoted to `public` under [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md).
- A domain may share internal helper code across its own files freely. It may not reach into another domain's internal helpers — if two domains need the same internal helper, that helper is promoted to a shared internal target-level utility (see §9) or the sharing is reconsidered, not routed around via `@testable`-style access.
- No file-private (`fileprivate`) type is referenced by name across files. If two files in the same domain need to share a type, it is `internal`, declared once, in the file most representative of its purpose.

## 5. Module Boundaries (Current and Future)

**Current state:** the package ships a single target, `SxnnyErgo`, compiling all six domains into one module. This is acceptable at current scale and is not something Epic 0 changes.

**Future state**, to be adopted only when a domain's compile time, dependency footprint, or audience genuinely diverges from the rest (see [PACKAGE_MODEL.md](PACKAGE_MODEL.md) for the full target-splitting model and its triggers): domains may be extracted into separate targets within the same package, consumed individually via multiple `.library` products. The folder-per-domain structure defined in §1 is deliberately chosen so that a future domain-to-target promotion is a `Package.swift` change plus a directory move — not a redesign. This is the entire reason folder structure and domain ownership are specified now, before any module split is warranted.

## 6. Visibility Rules

- `public`: symbols that satisfy [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) in full.
- `internal` (default, unmarked): everything else, including all cross-file-but-intra-domain helpers.
- `private`: implementation detail scoped to a single file, used liberally.
- `fileprivate`: avoided in favor of `private` unless multiple types in one file genuinely need shared access that `private` (type-scoped) cannot express.
- No `public` type is prefixed with an underscore. No underscore-prefixed type is used anywhere outside truly private-implementation contexts (correcting `_ValidationButtonLabel`).

## 7. Shared Code Rules

- Shared code that does not belong to any single domain (e.g., an internal test helper, a shared internal geometry utility used by both `Modifiers/` and `Platform/`) lives in an `Internal/` folder at the same level as the domain folders, and every symbol inside it is `internal` — `Internal/` never contains a `public` declaration. If a symbol inside `Internal/` becomes generally useful enough to be public, it is moved into the domain folder it most belongs to and evaluated under [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) like anything else.
- No domain-model types (application-specific data structures like the former `ChartData`, `Coordinate`, `InspectionItem`) are shared code. Domain-specific data models have no home in this architecture at all — they are out of scope per [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) and [VISION.md](VISION.md) §7, not merely relocated.

## 8. File Organization

- One primary public type or a small family of tightly related types per file. A file is named after the primary symbol it declares (see [NAMING.md](NAMING.md) §Files).
- A file that defines both a public type and its private implementation detail keeps both together in the same file — do not split a cohesive component across files purely to separate "public" from "internal" unless the file exceeds roughly 300 lines, at which point splitting by concern (e.g., `Component.swift` + `Component+Style.swift`) is preferred over an arbitrary line-count split.
- No file mixes declarations belonging to two different domains, regardless of length. A short file in the wrong domain is still in the wrong domain.

## 9. Extension Organization

- An extension on a standard library or SwiftUI type (`View`, `Binding`, `Collection`, `String`) lives in the domain folder matching what the extension *does*, not what type it extends. A `View` extension that toggles visibility lives in `Modifiers/`; a `View` extension that adjusts platform layout lives in `Platform/`. The extended type is not the classifier — the domain is.
- Each domain folder may contain multiple extension files split by the specific type extended (`Collections/Array+SxnnyErgo.swift`, `Collections/Optional+SxnnyErgo.swift`) once the domain grows past a handful of declarations in a single file; until then, a single file per domain is acceptable.
- Retroactive conformances (a type made to conform to a protocol it didn't originally conform to) are documented at the point of declaration with a doc comment explaining why the conformance lives in this package rather than upstream.

---

## Non-Goals of This Document

This document does not:
- Direct any current file to move (that is refactoring work for a later epic)
- Define which specific symbols exist in which domain (see [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md))
- Define the target/module split itself (see [PACKAGE_MODEL.md](PACKAGE_MODEL.md))
