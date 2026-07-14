# Public API Policy

> Normative. Governs when a symbol may become `public`, and how public commitments are kept or broken.
> Authority: [VISION.md](VISION.md) §10–§11 (Compatibility & Stability Policy).

[API_DESIGN.md](API_DESIGN.md) defines how a public API is *shaped*. This document defines whether it is *eligible* to be public at all, and what happens to it afterward.

---

## 1. When Something Can Become Public

A symbol may be marked `public` only when **all** of the following are true simultaneously:

1. **Domain fit.** It belongs to exactly one domain in [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) and satisfies that domain's inclusion criteria.
2. **Shape compliance.** It satisfies every applicable rule in [API_DESIGN.md](API_DESIGN.md) and [NAMING.md](NAMING.md).
3. **Documentation complete.** Per §4 below.
4. **Tested.** Per §5 below.
5. **No known functional defect.** It behaves exactly as its name and documentation claim, verified by the test suite, not merely by manual inspection. An API that animates unconditionally due to an internal bug, or applies an unconditional side effect its name doesn't promise, does not ship regardless of how useful its intended behavior would be.
6. **Reviewed against the five-year question.** [API_DESIGN.md](API_DESIGN.md) §14 has been explicitly considered and answered in the PR description, not silently skipped.

A symbol failing any one of these conditions stays `internal` until it passes. There is no "ship now, fix later" path for public API — deprecation policy (§7) exists for *retiring* mistakes, not for tolerating known ones at launch.

## 2. Minimum Quality Requirements

- Zero known functional bugs at time of shipping `public`.
- Zero `precondition`/`fatalError` triggerable by a caller passing well-typed but "unexpected" values (e.g., an array of the "wrong" count) — see [API_DESIGN.md](API_DESIGN.md) §4. Contract violations expressible in the type system are enforced by the type system; everything else fails gracefully.
- No hardcoded locale-specific, brand-specific, or otherwise non-neutral default value reachable without explicit override.
- No dead code path: no `#available` branch that is unreachable given the package's declared minimum platform versions. If the minimum deployment target makes a branch unreachable, the branch is deleted, not left as inert noise.
- No unused import in the file declaring the symbol (a data model importing `SwiftUI` for `Equatable` conformance alone is not shipped as-is).

## 3. Testing Requirements

- Every public symbol has at least one unit test exercising its documented behavior, including edge cases implied by its own doc comment (empty collection, nil optional, boundary values for clamping).
- A modifier or component with animation must have a test (or, where XCTest/Swift Testing cannot directly assert animation state, an explicit code-level invariant check) proving the animation trigger is keyed to an actual state change — not a constant or a fresh `UUID()` per evaluation. This is a direct response to a prior class of animation bugs keyed off unstable identity values.
- Concurrency-sensitive code (anything using `actor`, `Task`, `withCheckedContinuation`) has a test demonstrating correct behavior under cancellation, or is redesigned to avoid the concurrency hazard before it ships public.
- Platform-specific behavior (UIKit-bridged types) is tested on every platform the symbol claims to support, or the symbol's `@available` / platform-guard declarations are narrowed to only the platforms actually exercised.
- No public symbol ships whose sole test is a smoke test asserting that a stored property equals the value it was just assigned. That pattern verifies the Swift language, not the library, and does not count toward this requirement.

## 4. Documentation Requirements

- Every public symbol carries a DocC-compatible comment: one-sentence summary, `- Parameters:` for each parameter, `- Returns:` where non-`Void`, and at least one runnable usage example showing the call site — not the implementation.
- Documentation describes what a caller experiences, never internal mechanism, per [VISION.md](VISION.md) §9 ("Documentation-Driven Design").
- Any parameter that currently has no effect on behavior is never documented as "reserved for future use" and shipped anyway — either the parameter does something, or it does not exist.
- Any non-obvious behavioral trade-off (e.g., generic vs. type-erased overload performance) is documented at the point where a developer would need to choose between two similar APIs, following the existing correct example in `If.swift`'s documented generic-vs-`AnyView` trade-off.

## 5. Source Compatibility

- Once `public` and shipped in a minor/patch release, a symbol's name, parameter labels, parameter order, and return type do not change without a **major** version bump.
- Adding a new parameter to an existing public initializer or function is permitted in a minor release only if the new parameter has a default value, preserving every existing call site.
- Changing a symbol from a concrete return type to `some View`/an opaque type (or vice versa) is treated as a breaking change if it affects any expression where callers might store the value with an explicit type annotation.
- A `public struct` with a synthesized memberwise initializer is a stability commitment on its entire field set — adding a field breaks every direct-construction call site. New fields on such types require either a non-memberwise public initializer with defaults, or a builder-style construction path, decided at the type's original design time per [API_DESIGN.md](API_DESIGN.md) §14, not retrofitted after the fact.

## 6. Binary Compatibility Considerations

SxnnyErgo is source-distributed (Swift Package Manager), not shipped as a binary framework, so strict ABI stability does not apply. Nonetheless:

- Avoid `@inlinable` on any function whose body may need to change behavior across a minor version without a major bump — an `@inlinable` function's implementation is effectively frozen into every calling module's compiled output at the version it was built against. Apply `@inlinable` only per [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) §`@inlinable` guidance — never as a blanket default, and never on a function that isn't actually eligible for meaningful inlining benefit — that domain no longer exists in this package per [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md).
- Enum cases in a public, non-`@frozen` enum may be added in a minor release; a `@frozen` public enum's case set is permanently fixed and requires a major bump to change.
- Associated values on public enum cases (e.g., an error enum) are treated as part of the stable contract; changing them is a breaking change regardless of `@frozen` status.

## 7. Availability Rules

- Every public symbol's `@available` (or lack thereof) is checked against `Package.swift`'s declared platform minimums at review time. A symbol requiring a newer OS than the package minimum must either be marked `@available` accurately, or the feature is deferred until the package raises its minimum.
- A symbol available on a strict subset of the package's declared platforms (e.g., `@available(iOS 16.0, *)` in a package with an iOS 15 minimum) must document what happens on the unsupported-but-package-declared platform — silently absent APIs with no fallback and no documentation are not acceptable.
- Deployment target minimums are reviewed annually per [VISION.md](VISION.md) §10 and raising them is a deliberate, documented decision — not an incidental side effect of adding one new API that happens to need a newer OS.

## 8. Deprecation Policy

- A deprecated symbol carries `@available(*, deprecated, renamed: "...")` (or `message:` where no direct rename exists) pointing to its exact replacement. A deprecation with no replacement pointer is not acceptable.
- A deprecated symbol remains functional for at least one full minor release cycle after the deprecation is introduced, per [VISION.md](VISION.md) §10.
- A deprecated symbol is removed only in a major version release, after its full deprecation window has elapsed.
- Deprecated symbols are never presented alongside their replacement with equal prominence in documentation, autocomplete-adjacent naming, or the README (see [API_DESIGN.md](API_DESIGN.md) §9, Progressive Disclosure).
- The package does not accumulate parallel deprecated families indefinitely. If, at the time a symbol is deprecated, other deprecated symbols in the same domain have already passed their minor-release window, they are removed in the next major version — deprecation is a queue with an exit, not a permanent holding area (see, on the accumulation of four deprecated button types).

## 9. Breaking Change Policy

- Breaking changes are permitted only in a major version release (strict SemVer 2.0.0, per [VISION.md](VISION.md) §10). No exceptions, including for "obviously fixing a bug" — if fixing a bug changes observable behavior a caller could have depended on, it ships as a major-version change, or as a new symbol alongside a deprecation of the old one.
- Every major-version breaking change is accompanied by a migration note describing exactly what changed and how to update call sites, published alongside the release.
- A functional bug fix that does **not** change any documented, intended behavior (i.e., it makes actual behavior match already-documented behavior) is not a breaking change and may ship in a patch release. The distinction is: does this change what the documentation already promised, or does it change what was actually observable? Only the latter requires a major bump.
- Version identifiers never use non-SemVer suffixes (`1.0.1a`, `1.0.1b`). Every release is a clean `MAJOR.MINOR.PATCH`.

---

## Release Gate Checklist

A release cannot be tagged until every item below is true for every public symbol introduced or changed since the last release:

- [ ] Domain fit confirmed against [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md)
- [ ] Shape compliance confirmed against [API_DESIGN.md](API_DESIGN.md) / [NAMING.md](NAMING.md)
- [ ] Zero known functional defects (§2)
- [ ] Test coverage present (§3)
- [ ] DocC documentation present with a usage example (§4)
- [ ] No breaking change outside a major version (§9)
- [ ] Deprecated symbols past their window are removed, not carried forward silently (§8)
- [ ] CHANGELOG entry uses strict SemVer with no placeholder text or URLs
