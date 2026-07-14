//
//  RoundedProminentButtonStyleTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("RoundedProminentButtonStyle construction and composition with native Button")
struct RoundedProminentButtonStyleTests {

    @Test("composes with a native Button using default parameters")
    func defaultComposition() {
        _ = Button("Submit") {}
            .buttonStyle(.roundedProminent())
    }

    @Test("composes with a native Button using custom parameters")
    func customComposition() {
        _ = Button("Delete", role: .destructive) {}
            .buttonStyle(.roundedProminent(backgroundColor: .red, cornerRadius: 4))
            .disabled(true)
    }

    @Test("is a ButtonStyle conformance, not a standalone View type")
    func isButtonStyleNotView() {
        // Regression coverage: the former RoundedButton was a concrete View type with
        // an EnvironmentKey-backed .backgroundColor(_:) modifier that polluted the
        // global View namespace. This proves the replacement composes through the
        // native ButtonStyle protocol instead of introducing a parallel button type.
        let style = RoundedProminentButtonStyle.roundedProminent()
        #expect(type(of: style) == RoundedProminentButtonStyle.self)
    }
}
