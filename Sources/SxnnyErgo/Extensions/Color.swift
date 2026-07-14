//
//  Color.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - Color Utilities

extension Color {

    // MARK: Initializers

    /// Creates a color from a hexadecimal RGB string (e.g., `"#FF5733"` or `"FF5733"`).
    ///
    /// Accepts an optional leading `#` and a 6-character RGB value. If parsing fails, the
    /// color defaults to black.
    ///
    /// ```swift
    /// let accent = Color(hex: "#FFB700")
    /// ```
    ///
    /// - Parameter hex: A hexadecimal RGB string.
    @inlinable
    public init(hex: String) {
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
    /// Useful when integrating design tool output (Sketch, Figma) that reports color as
    /// 8-bit-per-channel RGB rather than SwiftUI's native 0–1 range.
    ///
    /// ```swift
    /// let brand = Color(rgb: (red: 255, green: 183, blue: 0))
    /// ```
    ///
    /// - Parameter rgb: A tuple of red, green, and blue values in the range 0–255.
    @inlinable
    public init(rgb: (red: Double, green: Double, blue: Double)) {
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
    public init(rgba: (red: Double, green: Double, blue: Double, alpha: Double)) {
        self.init(
            red: rgba.red / 255.0,
            green: rgba.green / 255.0,
            blue: rgba.blue / 255.0,
            opacity: rgba.alpha
        )
    }

    /// Creates a color from CMYK components (0–1).
    ///
    /// For interoperability with print-oriented design assets that specify color in CMYK
    /// rather than RGB.
    ///
    /// - Parameter cmyk: A tuple of cyan, magenta, yellow, and black values in the range 0–1.
    @inlinable
    public init(cmyk: (cyan: Double, magenta: Double, yellow: Double, black: Double)) {
        let red = (1.0 - cmyk.cyan) * (1.0 - cmyk.black)
        let green = (1.0 - cmyk.magenta) * (1.0 - cmyk.black)
        let blue = (1.0 - cmyk.yellow) * (1.0 - cmyk.black)
        self.init(red: red, green: green, blue: blue)
    }

    // MARK: Brightness Adjustments

    /// Returns a lighter variant of the color by the given percentage.
    ///
    /// ```swift
    /// Rectangle().fill(baseColor.lighter(by: 0.2))
    /// ```
    ///
    /// - Parameter percentage: The amount to increase brightness (0–1). Defaults to `0.3`.
    /// - Returns: A lighter color. On platforms without RGB component extraction, returns
    ///   `self` unchanged.
    @inlinable
    public func lighter(by percentage: Double = 0.3) -> Color {
        adjustingBrightness(by: abs(percentage))
    }

    /// Returns a darker variant of the color by the given percentage.
    ///
    /// - Parameter percentage: The amount to decrease brightness (0–1). Defaults to `0.3`.
    /// - Returns: A darker color. On platforms without RGB component extraction, returns
    ///   `self` unchanged.
    @inlinable
    public func darker(by percentage: Double = 0.3) -> Color {
        adjustingBrightness(by: -abs(percentage))
    }

    /// Adjusts brightness up or down by the given percentage.
    ///
    /// Uses platform color extraction (`UIColor`/`NSColor`) to read RGB components, offsets
    /// each channel, and clamps to `[0, 1]`. On platforms without component extraction,
    /// returns `self` unchanged rather than producing an incorrect approximation.
    ///
    /// This is an implementation detail behind `lighter(by:)`/`darker(by:)` and is not
    /// exposed publicly — a raw signed-percentage brightness offset has no independent
    /// call-site meaning that `lighter`/`darker` don't already express more clearly.
    ///
    /// - Parameter percentage: Positive values lighten; negative values darken. Expected
    ///   range is roughly `[-1, 1]`.
    /// - Returns: An adjusted color where supported; otherwise `self`.
    @inlinable
    internal func adjustingBrightness(by percentage: Double) -> Color {
        #if canImport(UIKit)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
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
            // No RGB component extraction available on this platform; return unchanged
            // rather than guess at an approximation.
            return self
        #endif
    }

    // MARK: Adaptive Color

    /// Creates a color that resolves to `light` in light mode and `dark` in dark mode.
    ///
    /// On UIKit platforms this is backed by a dynamic `UIColor` that re-resolves per trait
    /// collection. On AppKit platforms this is backed by a dynamic `NSColor`. On platforms with
    /// neither, this falls back to always returning `light`, matching how `adjustingBrightness(by:)`
    /// documents its own no-op fallback on unsupported platforms.
    ///
    /// ```swift
    /// let cardBackground = Color(light: .white, dark: Color(white: 0.15))
    /// ```
    ///
    /// - Parameters:
    ///   - light: The color to use in light mode (and the fallback on unsupported platforms).
    ///   - dark: The color to use in dark mode.
    @inlinable
    public init(light: Color, dark: Color) {
        #if canImport(UIKit)
            self.init(
                UIColor { traits in
                    traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
                })
        #elseif canImport(AppKit)
            self.init(
                NSColor(name: nil) { appearance in
                    let isDark = appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
                    return isDark ? NSColor(dark) : NSColor(light)
                })
        #else
            // Fallback for platforms without UIKit/AppKit dynamic color support.
            self = light
        #endif
    }

    // MARK: Contrast

    /// Computes the WCAG relative-luminance-based contrast ratio between this color and `other`.
    ///
    /// Follows the standard WCAG 2.x formula: relative luminance is computed from linearized
    /// sRGB channels, then the ratio is `(L1 + 0.05) / (L2 + 0.05)` with `L1` the lighter
    /// (higher-luminance) color. The result ranges from `1` (no contrast) to `21` (black on white).
    ///
    /// This is the package's single canonical contrast-ratio implementation; prefer this over
    /// hand-rolled luminance math elsewhere.
    ///
    /// ```swift
    /// let ratio = Color.black.contrastRatio(with: .white) // 21
    /// let isReadable = textColor.contrastRatio(with: backgroundColor) >= 4.5 // WCAG AA for body text
    /// ```
    ///
    /// - Parameter other: The color to compare against.
    /// - Returns: The WCAG contrast ratio, in the range `[1, 21]`.
    @inlinable
    public func contrastRatio(with other: Color) -> Double {
        let l1 = relativeLuminance()
        let l2 = other.relativeLuminance()
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// The WCAG relative luminance of this color, computed from linearized sRGB channels.
    ///
    /// - Returns: A luminance value in the range `[0, 1]`, or `0` on platforms without
    ///   UIKit/AppKit color extraction.
    @usableFromInline
    internal func relativeLuminance() -> Double {
        #if canImport(UIKit)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
            return Color.linearizedLuminance(red: Double(r), green: Double(g), blue: Double(b))
        #elseif canImport(AppKit)
            let nsColor = NSColor(self)
            guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else { return 0 }
            return Color.linearizedLuminance(
                red: Double(rgbColor.redComponent),
                green: Double(rgbColor.greenComponent),
                blue: Double(rgbColor.blueComponent)
            )
        #else
            return 0
        #endif
    }

    /// Computes WCAG relative luminance from 0–1 sRGB channel values.
    @usableFromInline
    internal static func linearizedLuminance(red: Double, green: Double, blue: Double) -> Double {
        func linearize(_ channel: Double) -> Double {
            channel <= 0.03928 ? channel / 12.92 : pow((channel + 0.055) / 1.055, 2.4)
        }
        let r = linearize(red)
        let g = linearize(green)
        let b = linearize(blue)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
}
