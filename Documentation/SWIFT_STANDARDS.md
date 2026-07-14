# Swift Standards

> Normative. Engineering standards specific to the Swift language and toolchain, independent of API shape or product scope.
> Authority: [VISION.md](VISION.md) §10 (Swift 6, Concurrency).

---

## 1. Swift 6

- The package targets `swift-tools-version: 6.0` and full Swift 6 language mode. Strict concurrency checking is the language default under Swift 6 — it is not opted into via `.enableExperimentalFeature("StrictConcurrency")`, and that flag is not present in `Package.swift`. Carrying an "experimental" flag for behavior that is Swift 6's baseline is a leftover from a pre-6.0 migration and is corrected the next time `Package.swift` is touched.
- No file suppresses strict concurrency checking locally (`@preconcurrency` on an internal declaration, blanket `nonisolated(unsafe)`) without a comment explaining exactly what invariant makes the suppression safe.

## 2. Concurrency

- Prefer structured concurrency (`async`/`await`, `Task {}` scoped to a lifetime the caller controls, task groups) over unstructured, fire-and-forget `Task {}` calls with no cancellation path.
- Never wrap a `Task {}` inside `withCheckedContinuation`. `withCheckedContinuation` already suspends the calling context — spawning an inner unstructured task and resuming the continuation from within it discards structured cancellation and creates a task-leak risk under cancellation. Call the async work directly with `await` inside the continuation body, or better, avoid the continuation entirely if the wrapped work is already `async`. This pattern must not reappear anywhere in the codebase.
- A function that fires an unstructured background task with no way for the caller to await or observe its completion is not acceptable when the caller has any reason to sequence against that work (e.g., `resetTimer()` followed immediately by `log()` must not race). Provide an `async` variant the caller can await, even if a synchronous fire-and-forget convenience also exists.
- Any `Task {}` spawned in response to a user action inside a view or view-adjacent type is cancelled when the owning view disappears, or is scoped via `.task {}` (which cancels automatically) rather than a manually managed `Task`.

## 3. Sendable

- Every type crossing an isolation boundary (passed into a `Task`, stored in an `actor`, passed as a closure parameter to async APIs) conforms to `Sendable`, or is explicitly and narrowly marked `@unchecked Sendable` with a comment justifying why the compiler cannot verify it but a human has.
- Closures accepted as parameters that will be invoked from a different isolation context than the caller's are typed `@Sendable`, and the actual value calling code passes is verified — not merely annotated — to be safe to invoke from that context. An `@Sendable` annotation on a parameter is a compile-time promise about the closure's *capture list*, not a guarantee about *where the caller's underlying logic is safe to run*; document the actual execution context in the doc comment when it isn't obvious.
- Conditional `Sendable` conformance (`struct Foo<T>: Sendable where T: Sendable`) is preferred over an unconditional or `@unchecked` conformance whenever the generic parameter can reasonably be constrained.

## 4. MainActor

- `@MainActor` isolation is applied based on one rule: **a type is `@MainActor` if and only if it reads or writes UI state that must be synchronized to the main thread, or it wraps a UIKit/AppKit type.** It is not applied by copying the isolation of a similar-looking neighboring type without checking whether the same rationale actually applies.
- Every `@MainActor` annotation on a public type is deliberate, not incidental. The prior inconsistency — `ShadowedRoundedButton`, `FillIconButton`, `FitIconButton`, `ValidationButton` marked `@MainActor` with no documented reason while structurally identical `RoundedButton`/`IconButton` were not — is the failure mode this rule exists to prevent. When two types are structurally equivalent, their isolation must be equivalent too, or the difference is documented.
- SwiftUI `View` conformances do not need explicit `@MainActor` — the protocol requirement already isolates `body` — but any non-`View` public type holding observable UI state does.

## 5. Observation

- New observable reference types adopt the `@Observable` macro (Observation framework), not `ObservableObject`/`@Published`. `ObservableObject` is retained only on existing types until they can be migrated in a major version, per [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §9 — it is never used for new public API.
- `@Observable` types are `@MainActor`-isolated when they hold UI-relevant state, consistent with §4.

## 6. Availability

- `@available` annotations always match the actual minimum required by the API being guarded, verified against `Package.swift`'s declared platform minimums at the time of writing — not copied from a neighboring file's older annotation.
- No `#available` branch is written for a version already guaranteed by the package's deployment target. Existing dead branches of this kind are removed as part of any file touched for another reason, and no new dead branch is ever introduced.
- Every `@available` annotation includes a one-line comment stating which specific API requires that minimum, so a future deployment-target bump can find and remove stale guards mechanically rather than by re-deriving the reason.

## 7. Foundation Usage

- Import `Foundation` only for what is actually needed. Do not import `Foundation` solely for `UUID` — `UUID` has been part of the Swift standard library overlay since Swift 5.5.
- Do not import `SwiftUI` in a file whose declarations use no SwiftUI type — a pure data/value type conforming only to `Equatable`/`Hashable`/`Codable` imports `Swift`/`Foundation` as needed and nothing else.
- Prefer pure-Swift implementations over Foundation's Objective-C-bridged types on frequently-called paths. `Scanner`-based parsing (e.g., in hex color construction) is acceptable for correctness but is a known candidate for a pure-Swift rewrite if profiling shows it matters; new code on a hot path defaults to pure-Swift where a straightforward implementation exists.
- Expensive Foundation types (`DateFormatter`, `NumberFormatter`) are never constructed inside a function called per-render or per-cell. They are cached (`static let`, or an actor-isolated cache for thread-safety) exactly once and reused, following the existing correct pattern in `Date.defaultFormatter` — never the incorrect per-call pattern.

## 8. `@inlinable`

- `@inlinable` is applied only to functions that are (a) generic or otherwise plausibly specialized by the caller, and (b) small enough that inlining provides a measurable benefit, and (c) stable enough that their implementation is safe to freeze into caller binaries across minor versions (see [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §6).
- `@inlinable` is never applied to a non-generic wrapper around a system framework call (the misuse of `@inlinable` on `KeychainManager`'s `SecItemAdd`/`SecItemCopyMatching` wrappers, per [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md)).
- Every `@inlinable` declaration is paired with a comment stating why inlining is expected to help (specialization, hot-path elimination of dynamic dispatch).

## 9. `@usableFromInline`

- `@usableFromInline` is applied only to the specific `internal` symbols an `@inlinable` function actually needs to reference — never applied preemptively to a whole file's internal API in case something needs it later.
- Adding `@usableFromInline` to a symbol is treated as a stability commitment nearly as strong as making it `public` (its implementation is exposed to the module's ABI surface) — it goes through the same review rigor as a `public` declaration.

## 10. Extensions

- Follow [ARCHITECTURE.md](ARCHITECTURE.md) §9 for file/folder placement.
- An extension adding a protocol conformance a type doesn't naturally have (a retroactive conformance) documents, at the point of declaration, why the conformance is owned by this package rather than requested upstream.
- Extensions do not silently redefine behavior a caller would reasonably expect from the extended type's existing API (e.g., an extension method that shares a name with a near-synonymous stdlib member but behaves differently is renamed to avoid the collision — see [NAMING.md](NAMING.md) §11).

## 11. Result Builders

- A custom `@resultBuilder` is introduced only when `@ViewBuilder` (or an existing Swift/SwiftUI builder) cannot express the composition needed — not as a stylistic preference over a plain function or generic view-builder parameter.
- Any custom result builder ships with the same documentation rigor as any other public API under [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §4, including a full usage example, since result-builder syntax is inherently less discoverable than ordinary function calls.

## 12. Error Handling

- A function that can fail in a way callers should handle returns `throws` (or `Result<Success, Failure>` when the failure needs to be stored/passed around before handling) — never `precondition`/`fatalError` for a condition reachable by valid, well-typed caller input. See [API_DESIGN.md](API_DESIGN.md) §4 for the API-shape consequence; this section states the underlying Swift-level rule.
- Custom `Error` types are enums with meaningful, documented cases — not a single generic "something went wrong" case. Associated values on error cases are treated as part of the public contract (see [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §6) and are chosen deliberately.
- `try?`/`try!` are not used to silently discard a recoverable error inside library code. If an error is truly unrecoverable and expected never to occur given internal invariants, it is asserted with a descriptive `fatalError` message reserved for genuine programmer-error conditions unreachable via any public API misuse — not for conditions a caller could trigger by passing valid but "unexpected" data (again, see [API_DESIGN.md](API_DESIGN.md) §4).

## 13. Tooling

- SwiftLint (or an equivalent enforced linter) runs in CI and blocks merge on violations, specifically catching the class of defect enumerated in [NAMING.md](NAMING.md)'s Anti-Pattern Reference (camelCase violations, filename/type mismatches) mechanically rather than relying on manual review to catch them every time.
- The full platform matrix declared in `Package.swift` (iOS, macOS, watchOS, tvOS, visionOS) builds in CI on every pull request. A platform declared in `Package.swift` with no CI verification is not actually supported — either CI is added for it, or the platform is removed from the declared matrix until it is.
