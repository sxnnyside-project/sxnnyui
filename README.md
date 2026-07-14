# SxnnyErgo

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)
[![CI](https://github.com/Sxnnyside-Project/SxnnyErgo/workflows/CI/badge.svg)](https://github.com/Sxnnyside-Project/SxnnyErgo/actions)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%20%7C%20macOS%2012%20%7C%20tvOS%2015%20%7C%20watchOS%208%20%7C%20visionOS%201-blue)

<p align="center">
  <strong>Ergonomics-first ✦ Composable ✦ Cross-platform</strong><br>
  <em>The SwiftUI ergonomics layer Apple didn't ship.</em>
</p>

<p align="center">
  <a href="#about">About</a> ✦
  <a href="#features">Features</a> ✦
  <a href="#installation">Installation</a> ✦
  <a href="#usage">Usage</a> ✦
  <a href="#architecture">Architecture</a> ✦
  <a href="#contributing">Contributing</a>
</p>

---

## About

**SxnnyErgo** exists to make writing SwiftUI faster and more expressive. It's an ergonomics layer: a curated set of extensions, layouts, modifiers, and components that close specific, well-known gaps in native SwiftUI, so you write less boilerplate and more of the view logic that's actually yours.

Every public symbol earns its place by measurably reducing call-site friction — fewer lines, less ceremony, the API you reach for on instinct because it reads like something Apple would have shipped.

### Philosophy

> *"Ergonomics first: less boilerplate, more expressive SwiftUI, on every Apple platform."*

This is a Sxnnyside Project release.

## Features

- **Ergonomics first**: Every API exists to cut boilerplate and cognitive load at the call site — that's the product, not a side effect
- **Composability**: Small, focused APIs that combine well with native SwiftUI, not around it
- **Fully configurable**: No colors, fonts, or spacing imposed on your app — every API stays out of your app's visual decisions
- **Compatibility**: Cross-platform support across iOS, macOS, tvOS, watchOS, and visionOS

## Installation

### Prerequisites

- Swift 6.0+
- Xcode 16.0+

| Platform  | Minimum Version |
|-----------|-----------------|
| iOS       | 15.0            |
| macOS     | 12.0            |
| tvOS      | 15.0            |
| watchOS   | 8.0             |
| visionOS  | 1.0             |

### From Source

Add SxnnyErgo to your project using Xcode: **File → Add Package Dependencies...**, then enter:

```
https://github.com/Sxnnyside-Project/SxnnyErgo.git
```

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Sxnnyside-Project/SxnnyErgo.git", from: "2.0.0")
]
```

Then add `SxnnyErgo` to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["SxnnyErgo"]
)
```

Upgrading from a `SxnnyUI` 1.x dependency? See [MIGRATION.md](MIGRATION.md).

## Usage

```swift
import SwiftUI
import SxnnyErgo

struct ContentView: View {
    @State private var query = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Search", text: $query)
                .dismissesKeyboardOnTap()

            Button("Get Started") { }
                .buttonStyle(.roundedProminent())
        }
        .padding()
        .cardStyle()
    }
}
```

SxnnyErgo is organized into four domains. Every public symbol belongs to exactly one.

**Extensions** — on standard SwiftUI and Swift types: `Array`, `Binding`, `Collection`, `Color`, `View` (conditionals, visuals, lifecycle, async), `Image`, `StringProtocol`, `EnvironmentValues.platformIdiom`, `@Adaptive`.

**Layout** — structural view containers: `FlowLayout`, `EqualSizeLayout`, `BreakpointLayout`, `ModalOverlay`, `ResizableSplitView`.

**Modifiers** — `dismissesKeyboardOnTap()`, `minimumTappableFrame(_:)`, `accessibleAnimation(_:value:)`, `background(material:reduceTransparencyFallback:)`, `autoContrastForeground(on:light:dark:)`, `DynamicTypePreviewGrid`, focus navigation (`advanceToNextField()`, `focusOnAppear(_:)`), `shake(trigger:)`, `keyboardToolbar(content:)`, `.centerAligned`, `.topLabeledStyle`.

**Components** — `IconButton`, `RoundedProminentButtonStyle`, `Badge`, `TokenView`, `AnimatedNumericText`.

API reference documentation is available via DocC:

```bash
make docs
```

## Architecture

```
SxnnyErgo/
├── Sources/SxnnyErgo/    # Extensions, Layout, Modifiers, Components
├── Tests/SxnnyErgoTests/ # Unit tests, one file per public symbol group
└── Documentation/      # Engineering and product canon
```

For a detailed breakdown, see [Documentation/ARCHITECTURE.md](Documentation/ARCHITECTURE.md). The full canon — vision, API design, naming, public API policy, Swift standards, and the contributor workflow — is indexed in [Documentation/REPOSITORY_CANON.md](Documentation/REPOSITORY_CANON.md).

## Contributing

Contributions are accepted. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Before contributing, read the [Code of Conduct](CODE_OF_CONDUCT.md).

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>SxnnyErgo</strong> — A Sxnnyside Project<br>
  <em>&copy; 2025 Sxnnyside Project</em>
</p>
