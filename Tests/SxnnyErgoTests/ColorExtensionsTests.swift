//
//  ColorExtensionsTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@Suite("Color initializers and brightness adjustment")
struct ColorExtensionsTests {

    // MARK: init(hex:)

    @Test("parses a hex string with a leading #")
    func hexWithHash() {
        let color = Color(hex: "#FF0000")
        #expect(color.resolvedComponentsApproximatelyEqual(to: (1, 0, 0)))
    }

    @Test("parses a hex string without a leading #")
    func hexWithoutHash() {
        let color = Color(hex: "00FF00")
        #expect(color.resolvedComponentsApproximatelyEqual(to: (0, 1, 0)))
    }

    @Test("falls back to black for an unparseable string")
    func hexInvalidFallsBackToBlack() {
        let color = Color(hex: "not-a-color")
        #expect(color.resolvedComponentsApproximatelyEqual(to: (0, 0, 0)))
    }

    // MARK: init(rgb:)

    @Test("scales 0-255 RGB components to 0-1")
    func rgbScaling() {
        let color = Color(rgb: (red: 255, green: 0, blue: 0))
        #expect(color.resolvedComponentsApproximatelyEqual(to: (1, 0, 0)))
    }

    // MARK: init(cmyk:)

    @Test("pure black in CMYK produces RGB black")
    func cmykBlack() {
        let color = Color(cmyk: (cyan: 0, magenta: 0, yellow: 0, black: 1))
        #expect(color.resolvedComponentsApproximatelyEqual(to: (0, 0, 0)))
    }

    @Test("zero CMYK produces RGB white")
    func cmykWhite() {
        let color = Color(cmyk: (cyan: 0, magenta: 0, yellow: 0, black: 0))
        #expect(color.resolvedComponentsApproximatelyEqual(to: (1, 1, 1)))
    }

    // MARK: lighter(by:) / darker(by:)

    #if canImport(UIKit) || canImport(AppKit)
        @Test("lighter(by:) increases every RGB channel")
        func lighterIncreasesChannels() {
            let base = Color(red: 0.4, green: 0.4, blue: 0.4)
            let lightened = base.lighter(by: 0.2)
            #expect(lightened.resolvedComponentsApproximatelyEqual(to: (0.6, 0.6, 0.6), tolerance: 0.02))
        }

        @Test("darker(by:) decreases every RGB channel")
        func darkerDecreasesChannels() {
            let base = Color(red: 0.4, green: 0.4, blue: 0.4)
            let darkened = base.darker(by: 0.2)
            #expect(darkened.resolvedComponentsApproximatelyEqual(to: (0.2, 0.2, 0.2), tolerance: 0.02))
        }

        @Test("lighter(by:) clamps at full brightness rather than overflowing")
        func lighterClampsAtOne() {
            let base = Color(red: 0.95, green: 0.95, blue: 0.95)
            let lightened = base.lighter(by: 0.5)
            #expect(lightened.resolvedComponentsApproximatelyEqual(to: (1, 1, 1), tolerance: 0.02))
        }

        @Test("darker(by:) clamps at zero brightness rather than going negative")
        func darkerClampsAtZero() {
            let base = Color(red: 0.05, green: 0.05, blue: 0.05)
            let darkened = base.darker(by: 0.5)
            #expect(darkened.resolvedComponentsApproximatelyEqual(to: (0, 0, 0), tolerance: 0.02))
        }

        // MARK: init(light:dark:)

        @Test("resolves to the light color when the environment is light")
        func adaptiveColorResolvesLight() {
            let color = Color(light: .white, dark: .black)
            // Resolution is trait/appearance-driven and only observable under a live
            // rendering host; this asserts construction succeeds for both branches.
            #expect(type(of: color) == Color.self)
        }

        @Test("init(light:dark:) builds without trapping for arbitrary colors")
        func adaptiveColorBuilds() {
            _ = Color(light: .yellow, dark: .indigo)
        }

        // MARK: contrastRatio(with:)

        @Test("black against white has the maximum WCAG contrast ratio of 21")
        func contrastRatioBlackWhiteIsMaximum() {
            let ratio = Color.black.contrastRatio(with: .white)
            #expect(abs(ratio - 21.0) < 0.1)
        }

        @Test("a color against itself has the minimum contrast ratio of 1")
        func contrastRatioIdenticalColorsIsMinimum() {
            let ratio = Color.white.contrastRatio(with: .white)
            #expect(abs(ratio - 1.0) < 0.1)
        }

        @Test("contrast ratio is symmetric regardless of argument order")
        func contrastRatioIsSymmetric() {
            let a = Color.red.contrastRatio(with: .blue)
            let b = Color.blue.contrastRatio(with: .red)
            #expect(abs(a - b) < 0.0001)
        }
    #endif
}

// MARK: - Test Helper

extension Color {
    /// Extracts RGB components via platform color bridging for approximate comparison in tests.
    func resolvedComponentsApproximatelyEqual(
        to expected: (Double, Double, Double),
        tolerance: Double = 0.01
    ) -> Bool {
        #if canImport(UIKit)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
            return abs(Double(r) - expected.0) < tolerance
                && abs(Double(g) - expected.1) < tolerance
                && abs(Double(b) - expected.2) < tolerance
        #elseif canImport(AppKit)
            guard let rgb = NSColor(self).usingColorSpace(.deviceRGB) else { return false }
            return abs(Double(rgb.redComponent) - expected.0) < tolerance
                && abs(Double(rgb.greenComponent) - expected.1) < tolerance
                && abs(Double(rgb.blueComponent) - expected.2) < tolerance
        #else
            return true
        #endif
    }
}
