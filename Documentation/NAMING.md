# Naming

> Normative. Every identifier introduced into the public or internal surface of SxnnyErgo must satisfy this document.
> Authority: [VISION.md](VISION.md) §9 ("Strict Predictability").

The governing test for every name in this document: **a developer who knows SwiftUI and has never seen SxnnyErgo should be able to guess this name, or immediately understand it once seen, without reading documentation.**

---

## 1. Packages

The package name is `SxnnyErgo`. It does not change. Any future split into multiple products (see [PACKAGE_MODEL.md](PACKAGE_MODEL.md)) uses `SxnnyErgo` + a descriptive suffix for sub-products (e.g., a hypothetical `SxnnyErgoCore`), never an unrelated name.

## 2. Modules / Targets

If and when the package splits into multiple targets (see [PACKAGE_MODEL.md](PACKAGE_MODEL.md)), each target is named for the domain it contains, matching the folder name defined in [ARCHITECTURE.md](ARCHITECTURE.md) §1 exactly (e.g., a target named `Modifiers` compiling `Sources/Modifiers/`). No target is named generically (`Core`, `Utils`, `Shared`) unless it is the `Internal/`-equivalent shared target, in which case it is named `SxnnyErgoInternal` and is never a public product.

## 3. Types (structs, classes, actors)

- **No blanket `Sxnny` prefix.** The prefix is applied only to resolve a specific, real collision risk with a name Apple is likely to use, and each such use is justified in the type's doc comment. Default assumption: no prefix.
- A type name is a noun phrase describing what the value *is*: `ConditionalOverlay`, not `SxnnyOverlay`; `ClampedBinding`, not a verb or an implementation detail.
- Never name a type after its implementation mechanism. `TriggeredTextField` (communicates nothing about behavior, only that something internally is "triggered") is the canonical violation — rename for what it does, not how it's built.
- Never use a vague catch-all noun (`FocusText`, `Container`, `Manager`, `Data`) unless qualified enough to be unambiguous on its own. `AlertManager` is borderline-acceptable because "manager" pairs with a well-understood single responsibility (alert state); a bare `Manager` type is not.
- Adjective order follows English/Swift convention: adjective before noun. `LabelSwipeable` is backwards; `SwipeableLabel` is correct.
- A `Custom` suffix is prohibited. It communicates "not the default" without saying what the type actually does differently. Rename to describe the actual difference (`FontWeightPickerCustom` → e.g. `FontWeightPicker` with a parameter, not a second type at all — see [API_DESIGN.md](API_DESIGN.md) §9 on consolidating parallel families).
- A `Config` suffix is replaced with the type it configures plus `Style` or `Configuration` only when it mirrors an Apple-established pattern (`ButtonStyleConfiguration`). A bespoke `TopLabeledStyleConfig` is renamed to match that convention exactly (`TopLabeledContentStyle`) rather than inventing a new suffix vocabulary.

## 4. Protocols

- A protocol describing capability is named with an `-able`/`-ing` adjective or a noun describing the role (`Identifiable`, `Animatable`, `LabelStyle`). Follow the exact vocabulary Apple uses for parallel protocols (`ButtonStyle`, `LabelStyle` → a custom style protocol in this package is `<Thing>Style`, never `<Thing>Configuration` or `<Thing>Protocol`).
- Never suffix a protocol with `Protocol`. Swift naming convention treats the bare noun as the protocol name (`Identifiable`, not `IdentifiableProtocol`).

## 5. Enums

- Enum type names are singular nouns (`Axis`, not `Axes`).
- Do not redeclare an enum that duplicates a SwiftUI vocabulary type unless the case set is genuinely different. A local `Axis` enum shadowing `SwiftUI.Axis` (as in `SxnnyScrollView.Axis` and `SxnnySplitView.Axis`) is prohibited — use `SwiftUI.Axis` directly.
- Case names are lowerCamelCase nouns or short phrases, consistent with Swift's `Axis.horizontal`/`.vertical` model.

## 6. Structs

Same rules as §3 (Types). No additional struct-specific convention beyond: value-type "state" structs (e.g., `AlertState`) are named `<Domain>State` only when they represent transient UI state, not persisted/domain data (persisted domain data has no place in this package at all — see [PRODUCT_DOMAINS.md](PRODUCT_DOMAINS.md)).

## 7. Extensions

- An extension file is named `<ExtendedType>.swift` (`Binding.swift`, `Collection.swift`) when it extends exactly one type, or `<ExtendedType>+<Concern>.swift` (`Array+Chunking.swift`) once a domain has multiple extension files on the same type.
- Extension method names never restate the extended type's name. `collection.chunked(into:)`, not `collection.collectionChunked(into:)`.

## 8. Files

- A file is named after its single primary public declaration, matching case exactly (`RoundedButton.swift` declares `RoundedButton`). Capitalization typos (`LabeledTextfield.swift` for a type conventionally spelled `TextField`) are not acceptable — see.
- A file named after a whole framework (`UIKit.swift`) is prohibited — it implies broader scope than any file should claim. Name the file after the specific bridge or capability it provides (`UIKitTextFieldBridge.swift`).
- Multi-word file names use PascalCase with no separators, matching the type name exactly. No spaces, no underscores, no hyphens in `.swift` filenames.

## 9. Folders

Governed fully by [ARCHITECTURE.md](ARCHITECTURE.md) §1. Summary constraint restated here for completeness: PascalCase, no spaces, no punctuation other than a hyphen, named after a product domain — never after a Swift language construct ("Utilities", "Helpers", "Misc") or a grouping of convenience ("StructData").

## 10. Functions

- Functions with side effects or that perform an action are verb phrases (`resetTimer()`, `dismiss()`).
- Functions that compute and return a new value without mutating are noun phrases or read as a fluent English clause at the call site (`clamped(to:)`, `firstUppercased`).
- A function name must accurately describe its actual behavior. `animated(if:animation:)` that animates unconditionally due to an implementation bug is a naming violation as much as it is a correctness bug — the fix must make the name and the behavior agree.
- Boolean-returning functions/properties read as an assertion (`isEmpty`, `isValidEmail`, `hasPrefix`), never as an imperative or ambiguous noun.

## 11. Properties

- Stored and computed properties are noun phrases matching their content exactly.
- A property whose name is a bare wrapper synonym for an existing standard-library property (`StringProtocol.length` duplicating `.count`) is prohibited — it invites the reader to assume a semantic difference (as `.length` legitimately signals in Objective-C/NSString) that does not exist here. If no distinct behavior exists, do not add the property.
- Static/global constant collections use lowerCamelCase and are always camelCase-correct — no exceptions. Properties like `invertblackTextGradient` or `bluebackgroundGradient` fail this rule. This class of error is caught by lint (see [SWIFT_STANDARDS.md](SWIFT_STANDARDS.md) §Tooling) before merge, not by review.

## 12. View Modifiers

- Named as a fluent verb phrase readable at the call site as English: `.hidden(if:)`, `.cardStyle()`, `.dismissesKeyboardOnTap()` — not `.hideKeyboardWhenTappedAround()` (verbose form flagged in; corrected form follows SwiftUI's own terse-verb convention).
- A modifier name never implies a broader effect than it has, and never collides with a standard SwiftUI modifier name unless it is genuinely a drop-in, semantics-preserving extension of that modifier (which is rare and requires explicit sign-off — see [PUBLIC_API_POLICY.md](PUBLIC_API_POLICY.md)).

## 13. Environment Keys

- An `EnvironmentKey` type is named `<Concern>Key` internally (`SwipeEdgeKey`) and is never public. The public surface is exclusively the `EnvironmentValues` computed property (named after the concern, lowerCamelCase: `swipeEdge`) and a `View` modifier for setting it (`.swipeEdge(_:)`), per [API_DESIGN.md](API_DESIGN.md) §11.

## 14. Generic Parameters

- Single-purpose generic parameters use a descriptive single-word PascalCase name when their role is domain-specific (`Icon: View`, `Label: View`, `Content: View`), matching Apple's own convention in `Button<Label>`, `Toggle<Label>`.
- Generic parameters with no domain-specific role (rare in this package — most generics here are view-builder parameters) fall back to single uppercase letters (`T`, `U`) only for pure algorithmic generics with no natural name (e.g., a generic clamp function over `Comparable`).
- Never use a single letter for a parameter that has an obvious descriptive name available. `<T: View>` when the parameter is conceptually "the icon" is a missed opportunity for self-documentation.

---

## Anti-Pattern Reference (from the Engineering Audit)

The following are explicitly prohibited, cited by name so they are never reintroduced:

| Anti-pattern | Rule violated |
|---|---|
| `Sxnny`-prefixing a plain wrapper (`SxnnyXStack`, `SxnnyYStack`, `SxnnyZStack`) | §3 — no blanket prefix; also [API_DESIGN.md](API_DESIGN.md) §1, wrapper adds no behavior |
| `FocusText` | §3 — name communicates neither structure nor behavior |
| `TriggeredTextField` / `TriggerButton` | §3 — names implementation, not behavior |
| `LabelSwipeable` | §3 — adjective/noun order |
| `FontWeightPickerCustom` | §3 — `Custom` suffix |
| `_ValidationButtonLabel` (public, underscore-prefixed) | [ARCHITECTURE.md](ARCHITECTURE.md) §6 — underscore reserved for non-public |
| `TopLabeledStyleConfig` | §3 — non-idiomatic `Config` suffix |
| `hideKeyboardWhenTappedAround()` | §10/§12 — non-idiomatic verbosity |
| `backgroundColor(_:)` on global `View` | [API_DESIGN.md](API_DESIGN.md) §12 — component-specific modifier polluting global namespace |
| `invertblackTextGradient`, `bluebackgroundGradient`, etc. | §11 — camelCase violation |
| `LabeledTextfield.swift` | §8 — capitalization |
| `StringProtocol.length` | §11 — redundant wrapper implying false semantic difference |
| Local `Axis` enum (`SxnnyScrollView.Axis`) | §5 — shadows `SwiftUI.Axis` |
