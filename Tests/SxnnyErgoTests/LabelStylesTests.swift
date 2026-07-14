//
//  LabelStylesTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("CenterAlignedLabelStyle and TopLabeledContentStyle composition")
struct LabelStylesTests {

    @Test("centerAligned composes with a native Label via the static accessor")
    func centerAlignedComposition() {
        _ = Label("Inbox", systemImage: "tray")
            .labelStyle(.centerAligned)
    }

    @Test("topLabeledStyle composes with a native LabeledContent via the static accessor")
    func topLabeledStyleComposition() {
        _ = LabeledContent("Title", value: "Value")
            .labeledContentStyle(.topLabeledStyle)
    }
}
