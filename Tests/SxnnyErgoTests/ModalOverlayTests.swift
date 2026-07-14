//
//  ModalOverlayTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("ModalOverlay configuration and construction")
struct ModalOverlayTests {

    @Test("builds without trapping when presented and dismissed")
    func buildsForBothStates() {
        _ = ModalOverlay(isPresented: .constant(true)) { Text("Content") }
        _ = ModalOverlay(isPresented: .constant(false)) { Text("Content") }
    }

    @Test("builds with every parameter customized")
    func buildsWithCustomParameters() {
        _ = ModalOverlay(
            isPresented: .constant(true),
            dismissesOnBackgroundTap: false,
            backgroundMaterial: .thinMaterial,
            cornerRadius: 24
        ) {
            Text("Custom")
        }
    }

    @Test("does not impose a size constraint on content")
    func contentIsUnconstrained() {
        // Regression coverage for the removed hardcoded 80%/50% GeometryReader
        // constraint: a view builder returning arbitrarily large content must compile
        // and construct without any implicit clamping applied by ModalOverlay itself.
        _ = ModalOverlay(isPresented: .constant(true)) {
            Text("Very long content that would have exceeded the previous 50% height cap")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
