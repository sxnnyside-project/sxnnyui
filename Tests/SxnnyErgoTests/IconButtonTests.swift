//
//  IconButtonTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("IconButton construction across both initializers")
struct IconButtonTests {

    @Test("string-convenience initializer builds with default parameters")
    func stringConvenienceDefaults() {
        _ = IconButton(iconName: "star.fill", label: "Favorite") {}
    }

    @Test("string-convenience initializer builds with every parameter customized")
    func stringConvenienceCustomParameters() {
        _ = IconButton(
            iconName: "trash",
            label: "Delete",
            additional: "Removes permanently",
            isSelected: true,
            contentMode: .fill,
            cornerRadius: 8,
            gradient: LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom),
            shadowColor: .black,
            minWidth: 100,
            maxWidth: 200,
            minHeight: 100,
            maxHeight: 200
        ) {}
    }

    @Test("builder initializer builds with custom icon and label views")
    func builderInitializer() {
        _ = IconButton(
            action: {},
            icon: { Image(systemName: "square.and.arrow.up") },
            label: { Text("Share") }
        )
    }

    @Test("builder initializer builds with every parameter customized")
    func builderInitializerCustomParameters() {
        _ = IconButton(
            isSelected: true,
            additional: "Subtitle",
            cornerRadius: 20,
            gradient: nil,
            shadowColor: .gray,
            minWidth: 120,
            maxWidth: 300,
            minHeight: 120,
            maxHeight: 260,
            action: {},
            icon: { Image(systemName: "gear") },
            label: { Text("Settings") }
        )
    }

    @Test("does not require AnyView: IconGlyph is a concrete, non-erased type")
    func noAnyViewInConvenienceInitializer() {
        // Regression coverage: the string-convenience initializer previously produced
        // Icon == AnyView, Label == AnyView. It now resolves to concrete types.
        let button = IconButton(iconName: "bell", label: "Alerts") {}
        let typeName = String(describing: type(of: button))
        #expect(typeName.contains("IconGlyph"))
        #expect(!typeName.contains("AnyView"))
    }
}
