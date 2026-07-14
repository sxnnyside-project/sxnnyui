//
//  Platform.swift
//  SxnnyErgo
//
//  Platform-adaptation utilities: a single environment value describing the
//  running device/platform idiom, and a property wrapper for picking a value
//  based on horizontal size class.
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - Platform Idiom

/// A coarse description of the kind of device or platform a view is running on.
///
/// This consolidates what would otherwise be several separate booleans (`isPad`, `isMac`,
/// `isTV`, `isWatch`, `isVision`) into a single value suitable for a `switch`.
public enum PlatformIdiom: Sendable, Equatable {
    /// An iPhone or other compact/phone-class UIKit device.
    case phone
    /// An iPad.
    case pad
    /// A Mac, whether running AppKit natively or Mac Catalyst.
    case mac
    /// An Apple TV.
    case tv
    /// An Apple Watch.
    case watch
    /// A visionOS device.
    case vision
    /// A platform/idiom not covered by the other cases.
    case unspecified

    /// The idiom of the currently running platform, computed once per access.
    @MainActor
    public static var current: PlatformIdiom {
        #if os(visionOS)
            return .vision
        #elseif canImport(UIKit)
            switch UIDevice.current.userInterfaceIdiom {
            case .phone: return .phone
            case .pad: return .pad
            case .tv: return .tv
            case .mac: return .mac
            case .vision: return .vision
            default: return .unspecified
            }
        #elseif os(watchOS)
            return .watch
        #elseif canImport(AppKit)
            return .mac
        #else
            return .unspecified
        #endif
    }
}

// MARK: - Environment Key

private struct PlatformIdiomKey: EnvironmentKey {
    static let defaultValue: PlatformIdiom = .unspecified
}

extension EnvironmentValues {
    /// The idiom of the device/platform the current view hierarchy is running on.
    ///
    /// This mirrors how SwiftUI itself exposes platform-shaped context (for example
    /// `\.horizontalSizeClass`): read it with `@Environment`, don't set it in ordinary app
    /// code. Like any environment key it is technically always overridable further up the
    /// hierarchy — that matches native SwiftUI behavior and is useful for previews and tests.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @Environment(\.platformIdiom) private var idiom
    ///
    ///     var body: some View {
    ///         switch idiom {
    ///         case .phone: CompactLayout()
    ///         case .pad, .mac: RegularLayout()
    ///         default: CompactLayout()
    ///         }
    ///     }
    /// }
    /// ```
    public var platformIdiom: PlatformIdiom {
        get { self[PlatformIdiomKey.self] }
        set { self[PlatformIdiomKey.self] = newValue }
    }
}

// MARK: - Adaptive Value Property Wrapper

/// A property wrapper that picks between two values based on the current horizontal size class.
///
/// `@Adaptive` is a *value* picker: it resolves to one of two plain values, recomputing
/// automatically as `\.horizontalSizeClass` changes (courtesy of `DynamicProperty`). This is
/// complementary to view-level breakpoint switching (swapping entire view hierarchies at layout
/// breakpoints, as `BreakpointLayout` does) — use `@Adaptive` when you need a scalar/config value
/// (spacing, a count, a font size) to vary by size class, and a view-picking approach when you
/// need different views entirely.
///
/// ```swift
/// struct ContentView: View {
///     @Adaptive(compact: 2, regular: 4) private var columnCount: Int
///
///     var body: some View {
///         LazyVGrid(columns: Array(repeating: GridItem(), count: columnCount)) {
///             // ...
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct Adaptive<Value>: DynamicProperty {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let compact: Value
    private let regular: Value

    /// Creates an adaptive value that resolves to `compact` under a compact horizontal size
    /// class and `regular` otherwise (including when the size class is unavailable/`nil`, which
    /// SwiftUI reports on platforms without size classes, such as watchOS).
    ///
    /// - Parameters:
    ///   - compact: The value to use when `\.horizontalSizeClass == .compact`.
    ///   - regular: The value to use otherwise.
    public init(compact: Value, regular: Value) {
        self.compact = compact
        self.regular = regular
    }

    /// The value for the current horizontal size class.
    public var wrappedValue: Value {
        horizontalSizeClass == .compact ? compact : regular
    }
}
