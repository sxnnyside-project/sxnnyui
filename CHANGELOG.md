# Changelog

All notable changes to **SxnnyErgo** are documented here.

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

<!-- Nothing pending — every change below shipped in 2.0.0. -->

---

## [2.0.0] — 2026-07-14

### Added

- Repository-level developer experience tooling: a `Makefile` exposing a standard command surface (`build`, `test`, `format`, `format-check`, `lint`, `dead-code`, `check`, `clean`, `docs`, `install-hooks`); a root `.swift-format` configuration for deterministic formatting via the Swift 6 toolchain's bundled `swift-format`, applied across the whole tree so `make format-check` passes with zero warnings; a `.periphery.yml` config (`retain_public: true`) wired to `make dead-code` for unused-declaration detection; tracked git hooks in `.githooks/` (`commit-msg` enforcing Conventional Commits, `pre-commit` verifying staged-file formatting); a GitHub Actions CI workflow running format-check, build, test, and the dead-code scan on every push and pull request; and a `CLAUDE.md` for AI-agent onboarding.
- New API families closing the most-requested gaps in the surviving domains: `FlowLayout`, `EqualSizeLayout`, `Binding` element/dictionary/set-membership projection, `View.readSize(_:)`/`readFrame(in:_:)`, `View.onFirstAppear(_:)`, an accessibility modifier family (`minimumTappableFrame`, Reduce Motion/Transparency-aware modifiers, automatic contrast foreground, `DynamicTypePreviewGrid`), sequential focus navigation, `PlatformIdiom`/`@Adaptive`, debounced/throttled `.task(id:)` variants, `shake(trigger:)`, `Color(light:dark:)`/`contrastRatio(with:)`, SF Symbol ergonomics, `AnimatedNumericText`, and `keyboardToolbar(content:)`.

### Changed

- **Breaking:** the package is renamed from `SxnnyUI` to `SxnnyErgo` — the module name, product name, `import` statement, and repository name all change. `SxnnyUI` positioned the library around what it deliberately excludes (no theme, no opinions); `SxnnyErgo` states the actual product: an ergonomics layer for SwiftUI. Update `Package.swift` dependencies and every `import SxnnyUI` to `import SxnnyErgo`.
- The package was reviewed domain by domain against the engineering and product standards in [`Documentation/`](Documentation/). Every surviving public symbol was brought to production quality (documentation, tests, availability, concurrency); every symbol that did not meet the bar was removed or redesigned. This is a breaking release relative to `1.1.0`.
- `Package.swift` no longer sets `.enableExperimentalFeature("StrictConcurrency")` — strict concurrency is the default under `swift-tools-version: 6.0`.

### Fixed

- `View.animated(if:)` previously keyed its animation off a freshly generated `UUID()` on every evaluation, so it animated unconditionally regardless of the condition passed in. It now keys off the condition itself, as documented.
- `IconButton`'s background gradient no longer contains a dead `isSelected ? gradient : gradient` branch.
- Removed several `AnyView` type-erasure paths (`If.swift`'s convenience overloads, `IconButton`'s string-convenience initializer) that forced unnecessary structural-identity loss.

### Removed

- The theming system (`SxnnyTheme`) — a non-configurable, hardcoded design-token struct with no place in a SwiftUI ergonomics library.
- The `Manager/` domain (`AlertManager`, `KeychainManager`) — application infrastructure with no framework-level SwiftUI relationship.
- The `Utilities/` domain in full: leaked application-domain models (`ChartData`, `Coordinate`, `IdentifiableImage`, `InspectionItem`, `Token`) and general-purpose formatting/logging utilities (`DateFormat`, `TimeFormat`, `FloatFormatter`, `PhoneFormat`, `Logger`), superseded by native `Date.FormatStyle`, `Double.FormatStyle`, and `os.Logger`.
- Numerous native-SwiftUI wrapper types across `Layout/` and `Components/` whose only contribution was a default parameter value (`SxnnyYStack`, `SxnnyXStack`, `SxnnyZStack`, `SxnnyScaffold`, `SxnnyScrollView`, `SxnnyContainer`, `SxnnyForm`, `SxnnySection`, `SxnnyGrid` and its lazy variants, and others).
- Narrow-audience or broken components: `FontWeightPicker` and its family (removed for a `precondition` crash on caller-supplied input), `FocusText`, `ValidationLabel`, `LabelSwipeable`, `TriggeredTextField`, `FocusTextField`, `LabeledTextField`, and the already-deprecated `FillIconButton`/`FitIconButton`/`LabeledIconButton`/`ShadowedRoundedButton`/`TriggerButton`/`ValidationButton`.

---

## [1.1.0] — 2026-01-30

### Added

- Comprehensive documentation for all public APIs.
- `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, and `CHANGELOG.md`.
- Support for the visionOS 1.0+ platform.

### Changed

- Standardized naming conventions across all components.
- Improved API consistency for layout containers.
- Updated minimum Swift version to 6.0.
- Refactored internal architecture for better maintainability.

### Fixed

- Resolved inconsistencies in component naming patterns.
- Fixed documentation gaps in public interfaces.
- Corrected platform availability annotations.

### Security

- Established a security reporting procedure in `SECURITY.md`.
- Version 1.1.0 is the first officially supported stable release.

---

## [1.0.1c] — 2024

### Fixed

- Additional patch fixes following 1.0.1b.
- Experimental stability improvements.

---

## [1.0.1b] — 2024

### Fixed

- Patch fixes following 1.0.1a.
- Minor API adjustments.

---

## [1.0.1a] — 2024

### Fixed

- Initial patch following the 1.0.0 release.
- Bug fixes and minor improvements.

---

## [1.0.0] — 2024

### Added

- Initial public release.
- Core component library including buttons, labels, and text fields.
- Layout system with stacks, grids, and containers.
- Extension utilities for SwiftUI and UIKit.
- Theme management system.
- Manager components for alerts and keychain.
- Custom view modifiers.
- Support for iOS 15+, macOS 12+, tvOS 15+, watchOS 8+.

<!-- Versions prior to 1.1.0 were experimental, with unstable APIs. -->

---

[Unreleased]: https://github.com/Sxnnyside-Project/SxnnyErgo/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/Sxnnyside-Project/SxnnyErgo/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/Sxnnyside-Project/SxnnyErgo/compare/v1.0.1c...v1.1.0
[1.0.1c]: https://github.com/Sxnnyside-Project/SxnnyErgo/compare/v1.0.1b...v1.0.1c
[1.0.1b]: https://github.com/Sxnnyside-Project/SxnnyErgo/compare/v1.0.1a...v1.0.1b
[1.0.1a]: https://github.com/Sxnnyside-Project/SxnnyErgo/compare/v1.0.0...v1.0.1a
[1.0.0]: https://github.com/Sxnnyside-Project/SxnnyErgo/releases/tag/v1.0.0
