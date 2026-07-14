# API Design

> Normative. Governs every public symbol added to SxnnyErgo from this point forward.
> Authority: [VISION.md](VISION.md) §6, §9.

This document answers one question: **how should every future public API be designed?**
It does not evaluate the current API surface. Bringing the existing surface into compliance is the job of a later epic. See [REPOSITORY_CANON.md](REPOSITORY_CANON.md) for how this document relates to the others.

---

## 1. SwiftUI-First

A public symbol earns its place in SxnnyErgo only if it is expressed in terms SwiftUI itself would use.

- Extend existing SwiftUI types (`View`, `Binding`, `Color`, `Shape`) rather than introducing new top-level types that duplicate them.
- Never introduce a type whose only purpose is to rename or thinly wrap a native SwiftUI type (`VStack`, `HStack`, `ZStack`, `Axis`, `NavigationStack`). If the wrapped type's behavior is unchanged, the wrapper does not belong in the package. A wrapper is justified only when it changes behavior in a way that cannot be expressed as a modifier.
- Prefer a modifier (`View -> some View`) over a new container type whenever the same effect can be achieved by composition. Modifiers compose; new container types fragment the view hierarchy vocabulary.
- If an API cannot be expressed as an idiomatic SwiftUI value, modifier, or property wrapper, it does not belong in this package regardless of how useful it is (see [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md) for scope boundaries).

## 2. Naming Conventions

Full symbol-naming rules live in [NAMING.md](NAMING.md). This section states only the API-shape consequences of that policy.

- No blanket library prefix. `Sxnny` is not a namespace device. A prefix is used only to resolve a genuine collision with a type Apple is likely to ship (rare, and decided case by case, documented in the type's doc comment when applied).
- A type name must describe what it **is**, not how it is implemented or where it came from. `TriggeredTextField` and `FocusText` are the canonical counterexamples: the name leaks implementation detail or communicates nothing. A reader must be able to guess the type's role from its name alone.
- Follow Swift API Design Guidelines noun/verb conventions exactly: types and protocols are noun phrases, methods that mutate or perform an action are verb phrases, methods that return a new value without side effects read as noun phrases or fluent clauses (`func padded(by:)`, not `func pad(by:)`, when non-mutating).

## 3. Parameter Labels

- The first argument must not restate the type or the method name. `RoundedButton(text: "Submit", action: {})` violates this; native `Button("Submit") { }` is the reference shape.
- When two initializers or overloads express the same conceptual operation, their argument order and labels must match exactly. Divergent overloads (e.g., `IconButton`'s two initializers historically diverging in order) are a defect, not a style choice.
- Closures are always the trailing argument, and are the trailing closure at the call site whenever there is exactly one.
- A parameter label must name the *role* the argument plays, not the *type* passed. `destination:` for an arbitrary closure that performs no navigation is a mislabel; call it what it does.

## 4. Initializer Rules

- Initializers are lightweight, pure, and free of side effects. No I/O, no timers, no notification registration in `init`. Side-effecting setup happens in `.task`, `.onAppear`, or an explicit `start()`-style method — never as a consequence of constructing a value.
- Every initializer provides sensible, platform-appropriate defaults for every parameter that is not conceptually required. A caller should be able to construct the simplest useful instance with the fewest arguments possible, and reach full configurability through additional named arguments — not through a second, differently-shaped initializer.
- Do not encode contract violations as `precondition`/`fatalError` for anything an argument's *type* could rule out instead. If a constraint cannot be expressed in the type system, it must fail gracefully (optional-returning initializer, `throws`, or a clamped/coerced value with documented behavior) — never crash the host app. This is a direct response to `LimitedFontWeights`' `precondition(values.count == 3 || values.count == 5)`.

## 5. View Modifiers

- A modifier returns `some View`. Never a concrete type that shadows a standard modifier name (a type shadowing `View.padding(_:)` with its own concrete `padding(_:)` is prohibited). If a component needs its own configuration surface, name those methods distinctly from any `View` modifier name (`labelFontWeight(_:)`, not `padding(_:)`).
- A modifier does exactly one thing. Do not combine layout, styling, and behavioral changes into a single call.
- A modifier must never apply a hidden, non-optional side effect the name does not promise (e.g., a `ScrollView` wrapper silently forcing padding). Every visual or behavioral consequence of applying a modifier must be derivable from its name and its documented parameters alone.
- Modifiers that animate must key the animation off a value that actually changes with the condition being animated. Never key an `.animation(_:value:)` off a freshly generated `UUID()` — this is a functional bug, not a style nit, and is treated as a release blocker under [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md).

## 6. Builder APIs

- Prefer `@ViewBuilder` closures over enums, mode flags, or `Bool` toggles for expressing structural variation. A caller should be able to compose content the same way they compose any SwiftUI view tree.
- A builder-configured component (fluent modifier chain returning `Self` or a concrete generic) is permitted only when it cannot regress to plain `some View` modifiers, and only when a `Style`-protocol path (see §9) is not viable at the time it ships. Prefer the `Style` protocol pattern (`ButtonStyle`, `LabelStyle`) over a concrete fluent-chain type whenever the domain supports it — it is the only pattern that allows third-party customization without a source-breaking redesign later.
- Builder methods must never return a type that is a subtype match for `View` but not usable interchangeably with the rest of the modifier chain (the `FocusText<Content>.padding()` shadowing bug is the canonical failure mode).

## 7. Generic Design

- Prefer generic view-builder parameters (`<Icon: View, Label: View>`) over `AnyView` for any API accepting caller-provided content. `AnyView` erases structural identity and forces subtree re-renders; it is a last resort, not a default (see §10, Type Erasure Policy).
- Constrain generic parameters to the minimum protocol that expresses the requirement (`View`, `Identifiable`, `Hashable`, `Sendable`) — do not over-constrain (e.g., requiring `Codable` on a generic parameter that is never encoded).
- When a generic API also ships a convenience non-generic overload for a common case (e.g., `String`-based initializer alongside a builder-based one), the two must be structurally consistent per §3 — same label names, same relative ordering, same defaults where applicable.

## 8. Default Arguments

- Every default must match the equivalent native SwiftUI default when one exists. A layout type's default alignment must match its native counterpart (`VStack` defaults to `.center`; a spacing-only companion type must default to `.center` too, not `.leading`) unless the divergence is documented as an intentional, justified product decision — not an oversight.
- A default that is silently applied and cannot be turned off (unconditional padding, unconditional background, unconditional constraint) is prohibited. Every default must be overridable, and overriding it must fully remove the default's effect, not merely offset it.
- Defaults must never encode a hardcoded locale-specific string, color, or brand value into a general-purpose component. The `ValidationLabel` Spanish default string is the canonical violation. All user-facing default text ships in English and is fully overridable; localized defaults are the consuming app's responsibility.

## 9. Progressive Disclosure

- A domain's simplest, most common API must be the one that appears first in documentation, in the Quick Start, and in autocomplete ordering (via naming) — not the type-erased or most-configurable variant. `If.swift`'s `AnyView` overloads currently appear before the generic, non-erasing ones; this ordering is backwards and is called out explicitly as a defect.
- Deprecated APIs do not compete for discoverability with their replacements. A deprecated symbol carries `@available(*, deprecated, renamed: "...")` pointing unambiguously to the one replacement, and deprecated variants are never presented as equally valid options in documentation.
- A domain must have exactly one "obvious" entry point per concept (one button type family, one text field family). Parallel families that differ only in visual embellishment (`RoundedButton`, `ShadowedRoundedButton`, `FillIconButton`, `FitIconButton`) are consolidated into a single parameterized component (see `IconButton`'s `contentMode:` parameter as the correct pattern).

## 10. Type Erasure Policy

- `AnyView` is prohibited in any API surface reachable by default. It may be used only as an internal implementation detail never exposed as a return type, and only when no generic formulation is feasible.
- Conditional view composition (`if`/`ifLet`/`ifElse`) must be implemented with `@ViewBuilder` and `Group`, preserving structural identity, per the existing correct pattern in `If.swift`'s generic overloads. Type-erasing convenience overloads, if they exist at all, are not the default and are not documented first.
- Any exception to this policy requires a documented, specific justification in the symbol's DocC comment explaining why type erasure was unavoidable.

## 11. Environment Usage

- `Environment` is the correct mechanism for propagating visual/behavioral configuration through a view hierarchy (theming, tint, spacing overrides) — not static global structs, not singletons. `RoundedButton`'s `EnvironmentKey`-based `backgroundColor` is cited as the correct existing pattern to generalize.
- Every custom `EnvironmentKey` must ship with a public, documented modifier for setting it (`.sxnnyAccent(_:)`-style, named per [NAMING.md](NAMING.md)) — never require callers to write `.environment(\.customKey, value)` directly against a private key type.
- A component must never read from a hardcoded static/global value (à la current `SxnnyTheme.primary`) when an `Environment`-based override path is feasible. Global non-overridable state is a [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) release blocker.

## 12. Public vs. Internal APIs

- Default to `internal`. A symbol becomes `public` only when it satisfies [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) in full — this document defines *shape*; that document defines *eligibility*.
- Helper types that exist purely to compose a public component's internals (e.g., `_ValidationButtonLabel`) are `internal`, never `public` with an underscore prefix. An underscore-prefixed identifier is a private Swift convention signal and must never appear on a `public` declaration.
- `public extension` on a foundational SwiftUI type (`View`, `Color`, etc.) is reserved for genuinely general-purpose additions. A modifier meaningful to exactly one component must not be hung off the global `View` namespace (`backgroundColor(_:)` polluting `View` for `RoundedButton`'s benefit is the counterexample).

## 13. Deprecation Strategy

Full policy in [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) §Deprecation. The API-design consequence: a deprecated symbol's replacement must be a strict drop-in for the common case, or the deprecation must ship with a documented migration path in the doc comment. A deprecated symbol is never left without an `@available(*, deprecated, renamed:)` pointer to its replacement.

## 14. Evolution Strategy

- Every public type must be evaluated at design time against the question: *"If this cannot change for five years, is this still correct?"* Concretely:
  - Prefer protocol-based extensibility (`ButtonStyle`-shaped) over concrete builder types for any component likely to need visual variation later.
  - Prefer SwiftUI's own vocabulary types (`Axis`, `Alignment`) over redefining an equivalent local type. A local `Axis` enum that shadows `SwiftUI.Axis` is a naming collision waiting to become a breaking change.
  - Prefer `@Observable` over `ObservableObject` for all new observable state, since the ecosystem has moved and `ObservableObject` → `@Observable` is a source-breaking migration for consumers.
  - A public `struct` with all-public-mutable-var fields (an `AlertState`-shaped type) is accepted only when its field set is genuinely final; anticipate the next field and design the initializer/API to tolerate additive change (e.g., via a builder or a non-memberwise public initializer) rather than exposing a synthesized memberwise initializer as the sole construction path.

---

## Summary Checklist

Before a new public symbol merges, it must satisfy every item below:

- [ ] Expressed as a native SwiftUI extension/modifier, not a renamed wrapper
- [ ] Name describes role, not implementation ([NAMING.md](NAMING.md) compliant)
- [ ] First parameter does not restate type/method name
- [ ] Sibling overloads share label/order conventions
- [ ] Initializer is side-effect free
- [ ] All defaults are sensible, overridable, and match native equivalents where one exists
- [ ] No `AnyView` in the public return type
- [ ] No `precondition`/`fatalError` for a constraint expressible otherwise
- [ ] Uses `Environment` for configuration that should flow through a hierarchy
- [ ] Simplest form is the most discoverable form
- [ ] Passes the five-year evolution question in §14
