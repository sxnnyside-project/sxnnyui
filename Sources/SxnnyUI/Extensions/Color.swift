//
//  Color.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - Color Utilities

public extension Color {

    // MARK: Initializers

    /// Creates a color from a hexadecimal RGB string (e.g., "#FF5733" or "FF5733").
    ///
    /// - Note: This initializer supports an optional leading "#" and expects a 6‑character RGB value.
    ///   If parsing fails, the color defaults to black.
    ///
    /// - Parameter hex: A hexadecimal RGB string.
    @inlinable
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

    /// Creates a color from 0–255 RGB values.
    ///
    /// - Parameter rgb: A tuple of red, green, and blue values in the range 0–255.
    @inlinable
    init(rgb: (red: Double, green: Double, blue: Double)) {
        self.init(
            red: rgb.red / 255.0,
            green: rgb.green / 255.0,
            blue: rgb.blue / 255.0
        )
    }

    /// Creates a color from 0–255 RGB values and an alpha in 0–1.
    ///
    /// - Parameter rgba: A tuple of red, green, blue (0–255), and alpha (0–1) values.
    @inlinable
    init(rgba: (red: Double, green: Double, blue: Double, alpha: Double)) {
        self.init(
            red: rgba.red / 255.0,
            green: rgba.green / 255.0,
            blue: rgba.blue / 255.0,
            opacity: rgba.alpha
        )
    }

    /// Creates a color from CMYK components (0–1).
    ///
    /// - Parameter cmyk: A tuple of cyan, magenta, yellow, and black values in the range 0–1.
    @inlinable
    init(cmyk: (cyan: Double, magenta: Double, yellow: Double, black: Double)) {
        let red = (1.0 - cmyk.cyan) * (1.0 - cmyk.black)
        let green = (1.0 - cmyk.magenta) * (1.0 - cmyk.black)
        let blue = (1.0 - cmyk.yellow) * (1.0 - cmyk.black)
        self.init(red: red, green: green, blue: blue)
    }

    // MARK: Brightness Adjustments

    /// Returns a lighter variant of the color by the given percentage.
    ///
    /// - Parameter percentage: The amount to increase brightness (0–1). Defaults to `0.3`.
    /// - Returns: A lighter color. On non‑UIKit platforms, returns `self`.
    @inlinable
    func lighter(by percentage: Double = 0.3) -> Color {
        adjustBrightness(by: abs(percentage))
    }

    /// Returns a darker variant of the color by the given percentage.
    ///
    /// - Parameter percentage: The amount to decrease brightness (0–1). Defaults to `0.3`.
    /// - Returns: A darker color. On non‑UIKit platforms, returns `self`.
    @inlinable
    func darker(by percentage: Double = 0.3) -> Color {
        adjustBrightness(by: -abs(percentage))
    }
}

// MARK: - Private Helpers

private extension Color {
    /// Adjusts brightness up or down by the given percentage.
    ///
    /// Uses platform color extraction when available. On platforms without UIKit/AppKit extraction,
    /// this returns `self`.
    ///
    /// - Parameter percentage: Positive values lighten; negative values darken. Expected range is roughly [-1, 1].
    /// - Returns: An adjusted color where supported; otherwise `self`.
    @inlinable
    func adjustBrightness(by percentage: Double) -> Color {
        #if canImport(UIKit)
        // UIKit-backed extraction
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)

        let clamp: (CGFloat) -> CGFloat = { value in
            max(min(value + CGFloat(percentage), 1.0), 0.0)
        }

        return Color(
            red: Double(clamp(r)),
            green: Double(clamp(g)),
            blue: Double(clamp(b)),
            opacity: Double(a)
        )
        #elseif canImport(AppKit)
        // AppKit-backed extraction (macOS without UIKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else { return self }

        let r = rgbColor.redComponent
        let g = rgbColor.greenComponent
        let b = rgbColor.blueComponent
        let a = rgbColor.alphaComponent

        let clamp: (CGFloat) -> CGFloat = { value in
            max(min(value + CGFloat(percentage), 1.0), 0.0)
        }

        return Color(
            red: Double(clamp(r)),
            green: Double(clamp(g)),
            blue: Double(clamp(b)),
            opacity: Double(a)
        )
        #else
        // Fallback for platforms without UIKit/AppKit color extraction
        return self
        #endif
    }
}
