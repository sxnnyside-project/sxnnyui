# SxnnyUI

![SxnnyUI Logo](SxnnyUI.png)

[![Swift](https://img.shields.io/badge/swift-5.8%2B-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue.svg)](#requirements)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

SxnnyUI is a curated collection of reusable, themeable SwiftUI components and layout helpers designed to accelerate UI development across Apple platforms.

---

## Quick Overview

- **Purpose:** Provide well-documented, lightweight SwiftUI building blocks (buttons, labels, badges, layout containers, utilities).
- **Design Goals:** Ease of use, accessibility, theming, and cross-platform compatibility.
- **Integration:** Distributed as a Swift Package (SPM) and compatible with Xcode package workflows.

---

## Installation

Install via Swift Package Manager (recommended).

Add the package dependency to your `Package.swift` or use Xcode’s **File > Add Packages…** with the repository URL:

```swift
.package(url: "https://github.com/Sxnnyside-Project/SxnnyUI.git", from: "1.0.1c")
```

Or add the package in Xcode by pointing to the repository and choosing an appropriate version or branch.

---

## Example

This example demonstrates a simple SwiftUI view using core SxnnyUI components.

```swift
import SwiftUI
import SxnnyUI

struct ExampleView: View {
    var body: some View {
        SxnnyScaffold {
            SxnnyYStack(spacing: 16) {
                HStack {
                    Image(systemName: "bell")
                        .badge(count: 3)
                    Spacer()
                    FocusText("Welcome to SxnnyUI")
                        .backgroundColor(.accentColor)
                        .foregroundColor(.white)
                }

                RoundedButton(text: "Get Started") {
                    // Action
                }
                .backgroundColor(.blue)
            }
            .padding()
        }
    }
}
```

Notes:
- `Badge`, `FocusText`, and `RoundedButton` are examples of components provided in this package. Check the `Sources/SxnnyUI/Components` folder for additional views and usage notes.

---

## Project Structure (high-level)

- `Package.swift` : Swift package manifest
- `Sources/SxnnyUI/` : Library source code
  - `Components/` : UI components (Buttons, Labels, TextFields, etc.)
  - `Layout/` : Layout helpers and containers (stacks, grids, scaffold)
  - `Extensions/` : Small language and platform helpers
  - `Modifiers/` : View modifiers used across components
  - `Theme/` : Theming utilities
  - `Utilities/` : Logger, formatters, and small utilities
- `Tests/SxnnyUITests/` : Unit/UI tests
- `README.md`, `LICENSE` : Repo metadata

This is a top-level, non-exhaustive view — explore each folder for detailed APIs and documentation comments.

---

## Requirements

- Swift 5.8+
- Xcode 15+ recommended
- Supported platforms: iOS, macOS, tvOS, watchOS (see package APIs for availability annotations)

---

## Usage & Customization

- Theme components via environment values and the `Theme` utilities.
- Chain view modifiers on `FocusText`, `RoundedButton`, and others for concise styling.
- Use layout helpers (e.g., `SxnnyScaffold`, `SxnnyYStack`) to build responsive app UIs quickly.

---

## Development

- Run tests:

```bash
swift test
```

- Format with `swift-format` or `swift-format` rules used by the project (if configured).

---


## Contributing & Community

- Please read `CONTRIBUTING.md` for guidelines on reporting issues, running tests, and submitting pull requests.
- This project follows a community `CODE_OF_CONDUCT.md` — please review it before contributing.
- To report security issues privately, see `SECURITY.md` (do not post sensitive details publicly).
- Issue and pull request templates are provided in `.github/` to help triage and speed up reviews.

---

## License

SxnnyUI is released under the MIT License. See `LICENSE` for details.

---

## Contact

- Maintainer: Sxnnyside Project
- Repository: https://github.com/Sxnnyside-Project/SxnnyUI

If you find this package useful, please consider starring the repository.

---

*Last updated: November 2025*
