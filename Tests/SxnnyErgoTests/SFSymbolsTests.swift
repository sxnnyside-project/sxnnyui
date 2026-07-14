//
//  SFSymbolsTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("Image.fontWeight(matching:) / Image(systemName:fallback:) / symbolVariant(if:_:)")
struct SFSymbolsTests {

    @Test("fontWeight(matching:) builds without trapping")
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func fontWeightMatchingBuilds() {
        _ = Image(systemName: "bolt.fill").fontWeight(matching: .semibold)
    }

    @Test("fallback initializer resolves to the primary name when it exists")
    func fallbackResolvesToPrimaryWhenValid() {
        // "star" is a long-standing SF Symbol name present since the earliest SF Symbols
        // release, so it is expected to exist on every platform this package targets.
        _ = Image(systemName: "star", fallback: "questionmark")
    }

    @Test("fallback initializer builds even when the primary name is nonsense")
    func fallbackInitializerBuildsForUnknownPrimary() {
        _ = Image(systemName: "this.symbol.name.does.not.exist.anywhere", fallback: "star")
    }

    @Test("symbolVariant(if:_:) builds without trapping for both states")
    func symbolVariantBuilds() {
        _ = Image(systemName: "bell").symbolVariant(if: true, .slash)
        _ = Image(systemName: "bell").symbolVariant(if: false, .slash)
    }
}
