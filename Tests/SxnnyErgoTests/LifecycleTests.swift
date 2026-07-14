//
//  LifecycleTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("View.onFirstAppear")
struct LifecycleTests {

    @Test("builds without trapping")
    func builds() {
        _ = Text("x").onFirstAppear {}
    }

    @Test("the backing modifier starts with hasAppeared false")
    func modifierStartsUnappeared() {
        let modifier = OnFirstAppearModifier(action: {})
        #expect(modifier.hasAppeared == false)
    }

    @Test("composes with other modifiers in a chain")
    func composesInChain() {
        _ = Text("x")
            .padding()
            .onFirstAppear {}
            .background(Color.gray)
    }
}
