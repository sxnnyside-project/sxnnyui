//
//  AnimatedNumericTextTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

// AnimatedNumericText itself carries the package's @available(iOS 17, ...) gate;
// @Test/@Suite cannot be combined with a type-level @available, so the gate is not
// repeated here (matching the same constraint documented in FlowLayoutTests).
@MainActor
@Suite("AnimatedNumericText construction")
struct AnimatedNumericTextTests {

    @Test("builds from a Double value with default parameters")
    func buildsFromDouble() {
        _ = AnimatedNumericText(value: 42.5)
    }

    @Test("builds from an Int value with default parameters")
    func buildsFromInt() {
        _ = AnimatedNumericText(value: 42)
    }

    @Test("builds with a custom format and animation")
    func buildsWithCustomParameters() {
        _ = AnimatedNumericText(
            value: 3.14159,
            format: .number.precision(.fractionLength(2)),
            animation: .easeInOut
        )
    }

    @Test("composes with other modifiers in a chain")
    func composesInChain() {
        _ = AnimatedNumericText(value: 10)
            .font(.title)
            .foregroundStyle(.blue)
    }
}
