# Product Domains

> Normative. Defines the complete, closed set of domains SxnnyErgo is permitted to contain.
> Authority: [VISION.md](VISION.md) §7–§9 (Product Surface, Component/Utility Philosophy).

Every public symbol in SxnnyErgo belongs to **exactly one** of the six domains below. A symbol that does not clearly belong to one of these domains does not ship — the list is closed, not a starting point for growth. Adding a seventh domain is a product decision, not an engineering one, and requires revisiting this document deliberately (see [REPOSITORY_CANON.md](REPOSITORY_CANON.md) on stability expectations) rather than being backed into by accreting an unrelated symbol.

---

## Domain 1: View Modifiers

**Purpose.** Reduce boilerplate at the SwiftUI call site through composable `View -> some View` transformations. This is the domain that most directly delivers on the VISION's Pillar I (Ergonomics First) and is the library's primary first impression.

**Ownership.** Folder: `Modifiers/` (see [ARCHITECTURE.md](ARCHITECTURE.md) §1).

**Inclusion criteria** (a symbol qualifies if it satisfies all of):
1. It is expressible as a `View` extension returning `some View`.
2. It solves a problem that recurs across independent, unrelated application domains (not one app's specific need).
3. SwiftUI has no elegant native equivalent achievable in under ~10 lines.
4. It imposes no visual opinion — it changes structure or behavior, not brand-specific styling.

**Exclusion criteria.** A modifier that hardcodes a visual choice (a specific color, a specific shadow radius with no override) is a component-styling concern, not a modifier concern, and does not belong here even if shaped like a modifier.

**Examples (in-scope):** conditional application (`.if(_:transform:)`, `.ifLet(_:transform:)`, `.ifElse(_:then:else:)`), animated visibility toggling, conditional overlay attachment, generic card styling with platform-appropriate background/shadow.

---

## Domain 2: Binding Transformations

**Purpose.** Fill SwiftUI's genuine gap around derived, transformed, and validated `Binding<T>` values — a differentiated, defensible product pillar, not a peripheral utility.

**Ownership.** Folder: `Bindings/`.

**Inclusion criteria:**
1. It operates on or produces a `Binding<T>`.
2. It solves a data-flow problem recurring in form-driven, input-driven, or state-synchronization SwiftUI code.
3. Getting it correct requires real care (clamping semantics, optional-unwrapping semantics) — not a one-line convenience with no room for a subtle bug.

**Exclusion criteria.** A `Binding` helper that is really a UI component in disguise (e.g., a validated text field with its own visual chrome) belongs in a components domain — but per §7 (What This Library Does Not Contain), this package does not ship opinionated input components at all; see the note at the end of this document.

**Examples (in-scope):** numeric type conversion (`Binding<Int>.double`), range clamping (`.clamped(to:)`), optional unwrapping with default (`.replacingNil(with:)`), equality-derived boolean binding (`.isEqual(to:)`).

---

## Domain 3: Collection Extensions

**Purpose.** Provide correct, tested, `@inlinable` implementations of the collection utilities every non-trivial Swift codebase reimplements. Value is in correctness and universality, not novelty.

**Ownership.** Folder: `Collections/`.

**Inclusion criteria:**
1. It extends `Collection`, `Array`, `Dictionary`, `Sequence`, or `Optional`.
2. It is used in the majority of non-trivial Swift projects (frequency bar, not aesthetic bar).
3. Its naive implementation has a plausible off-by-one, index-safety, or performance bug — i.e., correctness difficulty is real, and having one trusted implementation has clear value.
4. It carries zero SwiftUI dependency; it must be valid outside of any UI context (it is a Swift-language utility, not a SwiftUI utility, but ships in this package because splitting it out would fragment a coherent developer experience — see [PACKAGE_MODEL.md](PACKAGE_MODEL.md) for how this may change).

**Exclusion criteria.** Utilities with no practical SwiftUI/app-development frequency — CS-exercise implementations (palindrome checks, string reversal) — are out regardless of correctness or elegance.

**Examples (in-scope):** safe subscripting (`collection[safe:]`), nil compaction (`.compacted()`), presence check (`.isNotEmpty`), grouping (`.grouped(by:)`), chunking (`.chunked(into:)`).

---

## Domain 4: Color & Shape Extensions

**Purpose.** Ergonomic, platform-safe color construction and shape/gradient utilities that `Color`'s native API does not provide.

**Ownership.** Folder: `Color/`.

**Inclusion criteria:**
1. It extends `Color`, `Shape`, or `ShapeStyle`/gradient-related types.
2. It solves a construction or transformation problem (hex parsing, brightness adjustment, interoperability with design-tool color formats) — not a specific aesthetic choice.
3. It imposes zero brand opinion. A *utility* for building a gradient is in scope; a *named, pre-built* gradient encoding specific hues (`blueTextGradient`, `selectedButtonGradient`) is not — that is an application's design system, not a library utility. Only pattern-based (non-color-specific) presets, if any, are considered, and only after explicit evaluation.

**Exclusion criteria.** Any named preset whose value is tied to a specific hue, brand, or "look" — see [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md) on why preset removal is a release gate, not a style note.

**Examples (in-scope):** `Color(hex:)`, RGB/RGBA tuple initialization, CMYK initialization, `.lighter(by:)`/`.darker(by:)`.

---

## Domain 5: String Extensions

**Purpose.** High-frequency string transformations used across day-to-day SwiftUI/app development.

**Ownership.** Folder: `Strings/`.

**Inclusion criteria:**
1. It extends `String`/`StringProtocol`.
2. It has genuinely high daily-use frequency in real application code (formatting user input, validating input, casing transformation).
3. It does not duplicate an existing standard-library member under a new name with no behavioral difference (see [NAMING.md](NAMING.md) §11 on `.length` vs `.count`).

**Exclusion criteria.** Computer-science-exercise implementations with no practical development frequency (palindrome check, string reversal, arbitrary repetition) are explicitly out, regardless of implementation quality.

**Examples (in-scope):** `firstUppercased`/`firstCapitalized`/`firstLowercased`, `.isBlank`/`.trimmed`, `.isValidEmail`, case-style transforms (`.camelCased`, `.snakeCased`, `.kebabCased`), `.onlyNumbers`.

---

## Domain 6: Platform Adaptation

**Purpose.** Eliminate `#if os(...)` branching from view bodies through composable, multi-platform-aware abstractions — one of the most underexposed genuine strengths of the existing codebase.

**Ownership.** Folder: `Platform/`.

**Inclusion criteria:**
1. It addresses a genuine cross-platform (iOS/macOS/watchOS/tvOS/visionOS) layout or behavior divergence.
2. It removes the need for a consumer to write `#if os(...)` in their own view body.
3. It does not silently take over layout in a way the consumer cannot see coming (a `GeometryReader`-wrapping abstraction must document and, where possible, avoid unconditionally consuming all available space).

**Examples (in-scope):** platform-adaptive background/appearance helpers, responsive layout abstraction (the successor to `SxnnyResponsiveView`, rebuilt to satisfy [API_DESIGN.md](API_DESIGN.md)).

---

## What This Library Does Not Contain

The following are permanently out of scope, not merely deprioritized. They fail every domain's inclusion criteria simultaneously and are excluded by [VISION.md](VISION.md) §7 directly:

- **Application infrastructure** — logging, alert-state management, keychain/secure-storage management. No SwiftUI dependency, no UI-ergonomics justification. (Former: `Logger`, `AlertManager`, `KeychainManager`.)
- **Domain-specific data models** — any struct representing a specific application's business data (chart points, geographic coordinates, inspection records, tokens). These are consumer-application code, never library code, regardless of how generic their name is made. (Former: `StructData/` — `ChartData`, `Coordinate`, `InspectionItem`, `Token`, `IdentifiableImage`.)
- **Custom styled UI components** — buttons, text fields, pickers, badges, or any component that dictates a specific visual brand or interaction pattern beyond what a modifier can express. A component-based UI kit is a different product than an ergonomics layer; SxnnyErgo is the latter. This includes narrow-audience input widgets (a font-weight picker), swipe-to-confirm interaction patterns, and any named container that is a renamed native SwiftUI primitive.
- **Networking, persistence, or business logic** of any kind.
- **Navigation frameworks, routers, or coordinators.**
- **Formatters requiring locale/context-sensitive design** (date, time, phone, float formatting) are excluded from the current domain set. They are a plausible *future* domain but are not admitted until a specifically-designed, well-scoped proposal for a `Formatting` domain is deliberately added to this document — they do not enter by accretion into an existing domain.

If a proposed contribution does not map cleanly onto Domains 1–6 above, the correct action is to say no, not to find the closest-fitting existing folder.
