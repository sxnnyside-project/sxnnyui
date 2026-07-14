//
//  KeyboardToolbarTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("View.keyboardToolbar")
struct KeyboardToolbarTests {

    @Test("builds without trapping")
    func builds() {
        _ = TextField("Amount", text: .constant(""))
            .keyboardToolbar {
                Spacer()
                Button("Done") {}
            }
    }

    @Test("composes with other modifiers in a chain")
    func composesInChain() {
        _ = TextField("Amount", text: .constant(""))
            .padding()
            .keyboardToolbar {
                Button("Done") {}
            }
            .background(Color.gray)
    }
}
