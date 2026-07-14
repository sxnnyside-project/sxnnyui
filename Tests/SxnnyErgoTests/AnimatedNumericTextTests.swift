//
//  AnimatedNumericTextTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

// AnimatedNumericText requires iOS 17/macOS 14. Swift Testing's `@Test` macro cannot
// be combined with `@available` on the function or an enclosing type (compile error),
// so each test guards its own body with `if #available` instead of gating at the
// declaration level.
@MainActor
@Suite("AnimatedNumericText construction")
struct AnimatedNumericTextTests {

    @Test("builds from a Double value with default parameters")
    func buildsFromDouble() {
        guard #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) else { return }
        _ = AnimatedNumericText(value: 42.5)
    }

    @Test("builds from an Int value with default parameters")
    func buildsFromInt() {
        guard #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) else { return }
        _ = AnimatedNumericText(value: 42)
    }

    @Test("builds with a custom format and animation")
    func buildsWithCustomParameters() {
        guard #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) else { return }
        _ = AnimatedNumericText(
            value: 3.14159,
            format: .number.precision(.fractionLength(2)),
            animation: .easeInOut
        )
    }

    @Test("composes with other modifiers in a chain")
    func composesInChain() {
        guard #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) else { return }
        _ = AnimatedNumericText(value: 10)
            .font(.title)
            .foregroundStyle(.blue)
    }
}
