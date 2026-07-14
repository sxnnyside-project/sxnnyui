//
//  PlatformTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("PlatformIdiom / EnvironmentValues.platformIdiom / @Adaptive")
struct PlatformTests {

    // MARK: PlatformIdiom

    @Test("current resolves to a non-nil, defined case")
    func currentResolvesToADefinedCase() {
        let idiom = PlatformIdiom.current
        #expect(PlatformIdiom.allTestCases.contains(idiom))
    }

    // MARK: EnvironmentValues.platformIdiom

    @Test("defaults to unspecified when not overridden")
    func defaultsToUnspecified() {
        let values = EnvironmentValues()
        #expect(values.platformIdiom == .unspecified)
    }

    @Test("can be overridden via the environment")
    func canBeOverridden() {
        var values = EnvironmentValues()
        values.platformIdiom = .pad
        #expect(values.platformIdiom == .pad)
    }

    // MARK: @Adaptive

    @Test("Adaptive stores both compact and regular values at construction")
    func adaptiveStoresBothValues() {
        _ = Adaptive(compact: 2, regular: 4)
        #expect(Bool(true))
    }

    @Test("Adaptive composes with generic value types")
    func adaptiveWorksWithArbitraryTypes() {
        _ = Adaptive(compact: "Compact", regular: "Regular")
        _ = Adaptive(compact: CGFloat(8), regular: CGFloat(16))
    }
}

extension PlatformIdiom {
    fileprivate static var allTestCases: [PlatformIdiom] {
        [.phone, .pad, .mac, .tv, .watch, .vision, .unspecified]
    }
}
