//
//  DismissesKeyboardOnTapTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("View.dismissesKeyboardOnTap() construction")
struct DismissesKeyboardOnTapTests {

    @Test("builds without trapping")
    func builds() {
        _ = TextField("Name", text: .constant("")).dismissesKeyboardOnTap()
    }

    @Test("composes with other modifiers in a chain")
    func composesInChain() {
        _ = VStack {
            TextField("Name", text: .constant(""))
            TextField("Email", text: .constant(""))
        }
        .padding()
        .dismissesKeyboardOnTap()
        .background(Color.gray)
    }
}
