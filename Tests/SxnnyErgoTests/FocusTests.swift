//
//  FocusTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("advanceToNextField / advancesFocusOnSubmit / focusOnAppear")
struct FocusTests {

    enum Field: Hashable, CaseIterable {
        case name, email, phone
    }

    @Test("advancesFocusOnSubmit builds without trapping")
    func advancesFocusOnSubmitBuilds() {
        _ = Text("x").advancesFocusOnSubmit(FocusState<Field?>().projectedValue)
    }

    @Test("focusOnAppear(_:equals:) builds without trapping")
    func focusOnAppearWithTargetBuilds() {
        _ = Text("x").focusOnAppear(FocusState<Field?>().projectedValue, equals: .name)
    }

    @Test("focusOnAppear(_:) builds without trapping for Bool focus state")
    func focusOnAppearBooleanBuilds() {
        _ = Text("x").focusOnAppear(FocusState<Bool>().projectedValue)
    }
}
