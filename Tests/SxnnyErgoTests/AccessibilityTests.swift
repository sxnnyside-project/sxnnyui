//
//  AccessibilityTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite(
    "minimumTappableFrame / accessibleAnimation / background(material:) / autoContrastForeground / DynamicTypePreviewGrid"
)
struct AccessibilityTests {

    // MARK: minimumTappableFrame(_:)

    @Test("minimumTappableFrame builds without trapping for the default and a custom minimum")
    func minimumTappableFrameBuilds() {
        _ = Text("x").minimumTappableFrame()
        _ = Text("x").minimumTappableFrame(60)
    }

    // MARK: accessibleAnimation(_:value:) — regression coverage mirroring the animated(if:) UUID bug

    @Test("accessibleAnimation keys its animation value off the caller's Bool, not a fresh UUID")
    func accessibleAnimationKeysOffValue() {
        let result = Text("x").accessibleAnimation(.spring(), value: true)
        let description = String(describing: type(of: result))
        #expect(description.contains("Bool"))
        #expect(!description.contains("UUID"))
    }

    @Test("accessibleAnimation builds without trapping for nil and non-nil animations")
    func accessibleAnimationBuilds() {
        _ = Text("x").accessibleAnimation(nil, value: 1)
        _ = Text("x").accessibleAnimation(.easeIn, value: 1)
    }

    // MARK: background(material:reduceTransparencyFallback:)

    @Test("background(material:reduceTransparencyFallback:) builds without trapping")
    func materialBackgroundBuilds() {
        _ = Text("x").background(material: .ultraThinMaterial, reduceTransparencyFallback: Color.white)
        _ = Text("x").background(material: .regular, reduceTransparencyFallback: Color.black)
    }

    // MARK: autoContrastForeground(on:light:dark:) — WCAG relative luminance

    @Test("chooses black text against a light background")
    func choosesDarkForegroundOnLightBackground() {
        let foreground = Color.white.accessibleContrastingForeground(light: .white, dark: .black)
        #expect(foreground == .black)
    }

    @Test("chooses white text against a dark background")
    func choosesLightForegroundOnDarkBackground() {
        let foreground = Color.black.accessibleContrastingForeground(light: .white, dark: .black)
        #expect(foreground == .white)
    }

    @Test("autoContrastForeground builds without trapping for both defaults and custom colors")
    func autoContrastForegroundBuilds() {
        _ = Text("x").autoContrastForeground(on: .yellow)
        _ = Text("x").autoContrastForeground(on: .indigo, light: .white, dark: .black)
    }

    // MARK: DynamicTypePreviewGrid

    @Test(
        "exposes at least the four representative categories from the API contract, including both accessibility extremes"
    )
    func representativeSizeCategoriesCoversTheContract() {
        let categories = DynamicTypePreviewGrid<Text>.representativeSizeCategories
        #expect(categories.contains(.small))
        #expect(categories.contains(.large))
        #expect(categories.contains(.accessibilityLarge))
        #expect(categories.contains(.accessibilityExtraExtraExtraLarge))
        #expect(categories.count >= 4)
    }

    @Test("DynamicTypePreviewGrid builds without trapping")
    func dynamicTypePreviewGridBuilds() {
        _ = DynamicTypePreviewGrid {
            Text("Preview content")
        }
    }
}
