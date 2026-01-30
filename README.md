<p align="center">
  <img src="SxnnyUI.png" alt="SxnnyUI" width="300"/>
</p>

<h1 align="center">SxnnyUI</h1>
<p align="center"><em>A lightweight, themeable SwiftUI component library for Apple platforms.</em></p>

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%20%7C%20macOS%2012%20%7C%20tvOS%2015%20%7C%20watchOS%208%20%7C%20visionOS%201-blue.svg)](#platform-support)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

## Overview

SxnnyUI provides a curated collection of reusable SwiftUI components, layout helpers, and utilities designed to accelerate UI development across Apple platforms.

### Design Principles

- **Composability** — Small, focused components that combine well
- **Consistency** — Unified theming via `SxnnyTheme`
- **Compatibility** — Cross-platform support with graceful degradation
- **Clarity** — Well-documented APIs following Swift conventions

## Requirements

| Platform  | Minimum Version |
|-----------|-----------------|
| iOS       | 15.0            |
| macOS     | 12.0            |
| tvOS      | 15.0            |
| watchOS   | 8.0             |
| visionOS  | 1.0             |

- Swift 6.0+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add SxnnyUI to your project using Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/Sxnnyside-Project/SxnnyUI.git
   ```
3. Select your version requirements

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Sxnnyside-Project/SxnnyUI.git", from: "1.0.0")
]
```

Then add `SxnnyUI` to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["SxnnyUI"]
)
```

## Usage

### Quick Start

```swift
import SwiftUI
import SxnnyUI

struct ContentView: View {
    var body: some View {
        SxnnyScaffold {
            SxnnyYStack(spacing: 16) {
                FocusText("Welcome to SxnnyUI")
                    .backgroundColor(.accentColor)
                
                RoundedButton(text: "Get Started") {
                    // Handle tap
                }
                .backgroundColor(.blue)
            }
            .padding()
        }
    }
}
```

## Public API

### Components

#### Buttons

| Component           | Description                                              |
|---------------------|----------------------------------------------------------|
| `RoundedButton`     | Customizable rounded button with environment theming     |
| `IconButton`        | Button with icon and label, supporting gradients         |
| `TriggerButton`     | Toggle button with primary/secondary actions             |
| `ValidationButton`  | Button that validates a condition before executing       |

#### Labels & Text

| Component                  | Description                                    |
|----------------------------|------------------------------------------------|
| `FocusText`                | Styled text with background, shadow, and radius|
| `Badge`                    | Notification badge overlay                     |
| `ValidationLabel`          | Swipe-to-validate label                        |
| `CenterAlignedLabelStyle`  | Accessibility-aware label style                |

#### Text Fields

| Component          | Description                                |
|--------------------|--------------------------------------------|
| `FocusTextField`   | Text field with `@FocusState` binding      |
| `LabeledTextField` | Labeled numeric text field                 |
| `TriggeredTextField`| UIKit-backed text field wrapper           |

### Layout

| Component             | Description                                        |
|-----------------------|----------------------------------------------------|
| `SxnnyScaffold`       | Screen structure with top bar, bottom bar, and FAB |
| `SxnnyYStack`         | Vertical stack with default spacing                |
| `SxnnyXStack`         | Horizontal stack with default spacing              |
| `SxnnyLazyYStack`     | Lazy vertical stack for large content              |
| `SxnnyLazyXStack`     | Lazy horizontal stack for large content            |
| `SxnnyScrollView`     | Scrollable container with axis configuration       |
| `SxnnyContainer`      | Padded, rounded, shadowed container                |
| `SxnnyOverlay`        | Modal overlay with dismissible background          |
| `SxnnySplitView`      | Resizable split view with draggable divider        |
| `SxnnyResponsiveView` | Adaptive layout for small/medium/large widths      |
| `SxnnyGrid`           | Grid layout                                        |
| `SxnnyLazyXGrid`      | Lazy horizontal grid                               |
| `SxnnyLazyYGrid`      | Lazy vertical grid                                 |
| `SxnnyForm`           | Form wrapper                                       |
| `SxnnySection`        | Section wrapper                                    |

### Utilities

| Utility           | Description                                |
|-------------------|--------------------------------------------|
| `SxnnyTheme`      | Centralized design tokens                  |
| `AlertManager`    | Observable alert state management          |
| `KeychainManager` | Secure keychain storage helpers            |
| `Logger`          | Throttled logging utility                  |

### Extensions

The library extends standard SwiftUI and Foundation types:

- **`View`** — Conditional modifiers, card styling, visibility helpers
- **`Color`** — Hex initialization, brightness adjustment, CMYK support
- **`Binding`** — Clamping, nil replacement, type conversion
- **`Collection`** — Safe indexing, chunking, grouping
- **`Date`** — Formatting, calendar checks
- **`StringProtocol`** — Case conversion, validation

### Formatters

| Formatter       | Description              |
|-----------------|--------------------------|
| `DateFormat`    | Date formatting helpers  |
| `TimeFormat`    | Time formatting helpers  |
| `FloatFormatter`| Number formatting        |
| `PhoneFormat`   | Phone number formatting  |

## Theming

Customize the visual appearance using `SxnnyTheme`:

```swift
// Access theme values
let spacing = SxnnyTheme.defaultSpacing
let background = SxnnyTheme.background
let accent = SxnnyTheme.accentColor
```

Component-specific styling uses environment values:

```swift
RoundedButton(text: "Submit") { }
    .backgroundColor(.green)
```

## Documentation

API documentation is available via DocC. Generate documentation locally:

```bash
swift package generate-documentation
```

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Security

To report security vulnerabilities, see [SECURITY.md](SECURITY.md).

## Code of Conduct

This project follows the Contributor Covenant. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

SxnnyUI is released under the MIT License. See [LICENSE](LICENSE) for details.

---

Maintained by [Sxnnyside Project](https://github.com/Sxnnyside-Project)
