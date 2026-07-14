//
//  TokenViewTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("TokenView construction and deletion callback")
struct TokenViewTests {

    @Test("stores the id and text it was created with")
    func storesConstructorValues() {
        let view = TokenView(id: 42, text: "Swift") { _ in }
        #expect(view.id == 42)
        #expect(view.text == "Swift")
    }

    @Test("onDelete is called with the token's id, not invoked at construction")
    func onDeleteReceivesID() {
        var deletedID: Int?
        let view = TokenView(id: 7, text: "Tag") { id in
            deletedID = id
        }
        #expect(deletedID == nil)
        view.onDelete(view.id)
        #expect(deletedID == 7)
    }

    @Test("is generic over any Hashable identifier type, not tied to any concrete model")
    func genericOverIdentifierType() {
        // TokenView has no dependency on any concrete data model — UUID, Int, and
        // String identifiers all work directly.
        _ = TokenView(id: UUID(), text: "A") { (_: UUID) in }
        _ = TokenView(id: 1, text: "B") { (_: Int) in }
        _ = TokenView(id: "custom-id", text: "C") { (_: String) in }
    }
}
