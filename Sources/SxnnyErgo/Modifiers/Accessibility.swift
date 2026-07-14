//
//  Accessibility.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 14/07/26.
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

// MARK: - Accessibility
//
// Accessible behavior should be the default, easy path, not an opt-in a caller has to
// remember and hand-roll on every screen. Each API in this file targets one specific,
// well-known accessibility footgun (sub-44pt tap targets, motion that ignores Reduce
// Motion, transparency that ignores Reduce Transparency, low-contrast text against a
// runtime-determined background, and Dynamic Type layout breakage that's invisible
// until a user with a large text size hits it) and makes the correct behavior a single
// modifier call.

// MARK: - Minimum Tappable Frame

extension View {
    /// Guarantees the view's hit-testable area is at least `minimum` × `minimum` points,
    /// without changing the view's visual/rendered size.
    ///
    /// SwiftUI views often render smaller than the iOS Human Interface Guidelines' 44×44pt
    /// minimum tap target (a small icon button, a compact toggle). Growing the view itself
    /// to meet that minimum would change its layout footprint and could throw off
    /// surrounding spacing. This modifier instead overlays an invisible, centered region
    /// sized to at least the minimum and makes *that* the hit-testable shape, leaving the
    /// visible content exactly as small as it already is.
    ///
    /// ```swift
    /// Image(systemName: "xmark.circle.fill")
    ///     .font(.caption)
    ///     .minimumTappableFrame()
    ///     .onTapGesture { dismiss() }
    /// ```
    ///
    /// - Important: This expands the view's *hit-testable* area only. If the view sits
    ///   inside a stack that lays out neighbors based on this view's reported size, the
    ///   neighbors are unaffected — but the invisible tappable region can visually overlap
    ///   adjacent content, since it is centered on the original content rather than
    ///   reserved as layout space. Verify tight layouts don't produce overlapping tap
    ///   targets.
    /// - Parameter minimum: The minimum edge length, in points, of the tappable region.
    ///   Defaults to `44`, the HIG minimum tap target.
    /// - Returns: A view whose hit-testable area is at least `minimum` × `minimum`,
    ///   rendered at its original size.
    @MainActor
    public func minimumTappableFrame(_ minimum: CGFloat = 44) -> some View {
        self.overlay(
            Color.clear
                .frame(minWidth: minimum, minHeight: minimum)
                .contentShape(Rectangle())
        )
    }
}

// MARK: - Reduce-Motion-Aware Animation

extension View {
    /// Applies `animation` when Reduce Motion is off, and no animation at all when the
    /// user has Reduce Motion enabled.
    ///
    /// A drop-in replacement for `.animation(_:value:)` that respects
    /// `accessibilityReduceMotion` automatically, so callers don't have to read the
    /// environment and branch by hand at every call site.
    ///
    /// ```swift
    /// Circle()
    ///     .scaleEffect(isExpanded ? 1.5 : 1)
    ///     .accessibleAnimation(.spring(), value: isExpanded)
    /// ```
    ///
    /// - Parameters:
    ///   - animation: The animation to apply when Reduce Motion is off. Pass `nil` to
    ///     explicitly disable animation regardless of the Reduce Motion setting.
    ///   - value: The value to key the animation off. Only changes to this value trigger
    ///     the animation, matching the semantics of `.animation(_:value:)`.
    /// - Returns: A view that animates changes to `value`, unless Reduce Motion is enabled.
    @MainActor
    public func accessibleAnimation<Value: Equatable>(_ animation: Animation?, value: Value) -> some View {
        self.modifier(ReduceMotionAwareAnimationModifier(animation: animation, value: value))
    }
}

@MainActor
private struct ReduceMotionAwareAnimationModifier<Value: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let animation: Animation?
    let value: Value

    func body(content: Content) -> some View {
        content.animation(reduceMotion ? nil : animation, value: value)
    }
}

// MARK: - Reduce-Transparency-Aware Material Background

extension View {
    /// Applies `material` as a background when Reduce Transparency is off, and falls
    /// back to `fallback` (typically an opaque color) when the user has Reduce
    /// Transparency enabled.
    ///
    /// ```swift
    /// VStack { /* ... */ }
    ///     .background(material: .ultraThinMaterial, reduceTransparencyFallback: Color(.systemBackground))
    /// ```
    ///
    /// - Parameters:
    ///   - material: The material to use as a background under ordinary conditions.
    ///   - reduceTransparencyFallback: The opaque style substituted when
    ///     `accessibilityReduceTransparency` is enabled. Typically a solid `Color`.
    /// - Returns: A view with a background that respects the Reduce Transparency setting.
    @MainActor
    public func background(
        material: Material,
        reduceTransparencyFallback: some ShapeStyle
    ) -> some View {
        self.modifier(
            ReduceTransparencyAwareBackgroundModifier(
                material: material,
                fallback: reduceTransparencyFallback
            )
        )
    }
}

@MainActor
private struct ReduceTransparencyAwareBackgroundModifier<Fallback: ShapeStyle>: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let material: Material
    let fallback: Fallback

    func body(content: Content) -> some View {
        if reduceTransparency {
            content.background(fallback)
        } else {
            content.background(material)
        }
    }
}

// MARK: - Automatic Contrast Foreground

extension View {
    /// Sets the foreground style to whichever of `light` or `dark` has better contrast
    /// against `background`, so text and icons stay legible against a background color
    /// that is only known at runtime (user-picked, data-derived, or otherwise dynamic).
    ///
    /// ```swift
    /// Text(tag.name)
    ///     .padding(6)
    ///     .background(tag.color)
    ///     .autoContrastForeground(on: tag.color)
    /// ```
    ///
    /// - Parameters:
    ///   - background: The background color the foreground is being chosen to contrast
    ///     against.
    ///   - light: The foreground color used when it contrasts better against
    ///     `background` than `dark` does. Defaults to `.white`.
    ///   - dark: The foreground color used when it contrasts better against `background`
    ///     than `light` does. Defaults to `.black`.
    /// - Returns: A view whose foreground style is set to `light` or `dark`, whichever
    ///   yields higher contrast against `background`.
    @MainActor
    public func autoContrastForeground(on background: Color, light: Color = .white, dark: Color = .black) -> some View {
        self.foregroundStyle(background.accessibleContrastingForeground(light: light, dark: dark))
    }
}

extension Color {
    /// Returns whichever of `light` or `dark` yields higher WCAG-style contrast against
    /// this color, used as the background.
    ///
    /// This computes its own relative luminance rather than depending on any shared
    /// contrast-ratio utility elsewhere in the package, so it has no cross-file
    /// dependency on the color-contrast work in `Extensions/Color.swift`.
    @MainActor
    func accessibleContrastingForeground(light: Color, dark: Color) -> Color {
        let backgroundLuminance = Color.relativeLuminance(of: self)
        let lightLuminance = Color.relativeLuminance(of: light)
        let darkLuminance = Color.relativeLuminance(of: dark)

        let lightContrast = Color.contrastRatio(backgroundLuminance, lightLuminance)
        let darkContrast = Color.contrastRatio(backgroundLuminance, darkLuminance)

        return lightContrast >= darkContrast ? light : dark
    }

    /// WCAG 2.x relative luminance, computed from sRGB components resolved via
    /// `UIColor`/`NSColor` (so it works for any `Color`, including asset-catalog and
    /// dynamic colors, not just literal RGB initializers).
    fileprivate static func relativeLuminance(of color: Color) -> Double {
        let (r, g, b) = color.accessibleSRGBComponents()

        func linearize(_ component: Double) -> Double {
            component <= 0.03928 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * linearize(r) + 0.7152 * linearize(g) + 0.0722 * linearize(b)
    }

    /// WCAG 2.x contrast ratio between two relative luminance values.
    fileprivate static func contrastRatio(_ a: Double, _ b: Double) -> Double {
        let lighter = max(a, b)
        let darker = min(a, b)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// Extracts sRGB components in the 0...1 range from a `Color` via the platform's
    /// native color type, resolved against the current environment where possible.
    fileprivate func accessibleSRGBComponents() -> (Double, Double, Double) {
        #if canImport(UIKit)
            // Covers iOS, tvOS, and watchOS, all of which bridge `Color` through `UIColor`.
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
            return (Double(r), Double(g), Double(b))
        #elseif canImport(AppKit)
            let nsColor = NSColor(self).usingColorSpace(.deviceRGB) ?? NSColor(self)
            return (Double(nsColor.redComponent), Double(nsColor.greenComponent), Double(nsColor.blueComponent))
        #else
            // No known color-component accessor on this platform; fall back to a neutral
            // midpoint so the contrast calculation degrades gracefully instead of failing
            // to compile.
            return (0.5, 0.5, 0.5)
        #endif
    }
}

// MARK: - Dynamic Type Preview Grid

/// A developer-facing QA tool that renders `content` once per representative
/// `ContentSizeCategory`, each labeled with its category name, in a scrollable list —
/// intended for use inside `#Preview` blocks to catch Dynamic Type layout breakage
/// before it reaches a device.
///
/// ```swift
/// #Preview {
///     DynamicTypePreviewGrid {
///         Label("Settings", systemImage: "gear")
///             .padding()
///     }
/// }
/// ```
@MainActor
public struct DynamicTypePreviewGrid<Content: View>: View {
    /// The representative set of content size categories rendered by this preview.
    /// Spans the default size, the smallest standard size, and both ends of the
    /// accessibility range, which is where Dynamic Type layout bugs are most likely to
    /// surface.
    public static var representativeSizeCategories: [ContentSizeCategory] {
        [.small, .large, .accessibilityLarge, .accessibilityExtraExtraExtraLarge]
    }

    private let content: () -> Content

    /// Creates a Dynamic Type preview grid.
    ///
    /// - Parameter content: The view to render once per representative content size
    ///   category.
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        List(Self.representativeSizeCategories, id: \.self) { category in
            VStack(alignment: .leading, spacing: 8) {
                Text(String(describing: category))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                content()
                    .environment(\.sizeCategory, category)
            }
        }
    }
}
