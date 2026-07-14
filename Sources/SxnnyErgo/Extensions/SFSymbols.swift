//
//  SFSymbols.swift
//  SxnnyErgo
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

// MARK: - SF Symbol Utilities

extension Image {

    // MARK: Weight Matching

    /// Applies `weight` to the image, mirroring the way `Text` and `Image` symbols pick up a
    /// specific `Font.Weight`.
    ///
    /// SwiftUI does not expose a way to introspect an arbitrary `Font` value and recover its
    /// weight — `Font` is opaque past construction. Because of that, this takes a `Font.Weight`
    /// directly rather than a `Font`: the "matching" it performs is applying that explicit
    /// weight to the symbol, not inspecting a font you already have. If you're styling a symbol
    /// alongside text, pull the weight out at the call site and pass it here.
    ///
    /// ```swift
    /// Image(systemName: "bolt.fill")
    ///     .fontWeight(matching: .semibold)
    /// Text("Fast")
    ///     .fontWeight(.semibold)
    /// ```
    ///
    /// - Parameter weight: The symbol weight to apply.
    /// - Returns: The image with `weight` applied via `.fontWeight(_:)`.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @MainActor
    @inlinable
    public func fontWeight(matching weight: Font.Weight) -> some View {
        self.modifier(FontWeightMatchingModifier(weight: weight))
    }

    // MARK: Fallback Symbol Names

    /// Creates an SF Symbol image, falling back to `fallback` if `systemName` doesn't resolve
    /// to a symbol on the running OS.
    ///
    /// Useful when adopting a newer SF Symbol name while still supporting OS versions where
    /// only an older, differently-named equivalent exists.
    ///
    /// ```swift
    /// Image(systemName: "gearshape.2", fallback: "gear")
    /// ```
    ///
    /// - Parameters:
    ///   - systemName: The preferred SF Symbol name.
    ///   - fallback: The symbol name to use if `systemName` is unavailable.
    /// - Returns: An `Image` built from whichever name resolved to a real symbol.
    ///
    /// - Note: Symbol existence is probed via `UIImage(systemName:)` on UIKit platforms and
    ///   `NSImage(systemSymbolName:accessibilityDescription:)` on AppKit platforms. On platforms
    ///   with neither, there is no way to probe existence, so `systemName` is used unconditionally.
    public init(systemName: String, fallback: String) {
        #if canImport(UIKit)
            if UIImage(systemName: systemName) != nil {
                self.init(systemName: systemName)
            } else {
                self.init(systemName: fallback)
            }
        #elseif canImport(AppKit)
            if NSImage(systemSymbolName: systemName, accessibilityDescription: nil) != nil {
                self.init(systemName: systemName)
            } else {
                self.init(systemName: fallback)
            }
        #else
            self.init(systemName: systemName)
        #endif
    }

    // MARK: Conditional Symbol Variant

    /// Applies `variant` only when `condition` is `true`; otherwise leaves the image unchanged.
    ///
    /// Mirrors the `.if(_:transform:)` conditional-modifier family, scoped to `Image` and
    /// `SymbolVariants`.
    ///
    /// ```swift
    /// Image(systemName: "bell")
    ///     .symbolVariant(if: isMuted, .slash)
    /// ```
    ///
    /// - Parameters:
    ///   - condition: Whether `variant` should be applied.
    ///   - variant: The symbol variant to apply when `condition` is `true`.
    /// - Returns: The image with `variant` applied if `condition` is `true`; otherwise the
    ///   unmodified image.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor
    @inlinable
    public func symbolVariant(if condition: Bool, _ variant: SymbolVariants) -> some View {
        self.modifier(ConditionalSymbolVariantModifier(condition: condition, variant: variant))
    }
}

// MARK: - Modifiers (usable from inlinable)

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@usableFromInline
struct FontWeightMatchingModifier: ViewModifier {
    @usableFromInline let weight: Font.Weight

    @usableFromInline
    init(weight: Font.Weight) {
        self.weight = weight
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content.fontWeight(weight)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@usableFromInline
struct ConditionalSymbolVariantModifier: ViewModifier {
    @usableFromInline let condition: Bool
    @usableFromInline let variant: SymbolVariants

    @usableFromInline
    init(condition: Bool, variant: SymbolVariants) {
        self.condition = condition
        self.variant = variant
    }

    @usableFromInline
    func body(content: Content) -> some View {
        if condition {
            content.symbolVariant(variant)
        } else {
            content
        }
    }
}
