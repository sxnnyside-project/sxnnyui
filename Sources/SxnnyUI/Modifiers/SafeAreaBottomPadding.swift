//
//  SafeAreaBottomPadding.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// `SafeAreaInsetsKey` is a custom `EnvironmentKey` that stores the current safe area insets as an `EdgeInsets` value.
///
/// You can use this key to access safe area inset values from the environment within a SwiftUI view hierarchy.
/// This is particularly useful when you need to apply custom layouts or paddings that respect the device's safe areas.
///
/// By default, the value is an empty `EdgeInsets` instance (all edges set to zero), but you can override it by injecting
/// your own inset values higher up in the environment.
///
/// Example usage:
/// ```swift
/// @Environment(\.safeAreaInsets) private var insets: EdgeInsets
/// ```
private struct SafeAreaInsetsKey: EnvironmentKey {
    static let defaultValue: EdgeInsets = EdgeInsets()
}

extension EnvironmentValues {
    /// The current safe area insets available in the environment.
    ///
    /// Inject custom values higher in the view hierarchy if you need to override the defaults.
    var safeAreaInsets: EdgeInsets {
        get { self[SafeAreaInsetsKey.self] }
        set { self[SafeAreaInsetsKey.self] = newValue }
    }
}

/// `SafeAreaBottomPadding` is a SwiftUI `ViewModifier` that automatically applies bottom padding equal to the current safe area inset.
///
/// This is especially useful on devices with a home indicator or when your content extends to the edge of the screen.
/// By using this modifier, you can ensure that your view's bottom content is not obscured by system UI elements or device features.
///
/// Example usage:
/// ```swift
/// Text("Hello, world!")
///     .modifier(SafeAreaBottomPadding())
/// ```
///
/// Requirements:
/// - The `safeAreaInsets` environment value must be correctly provided in the view hierarchy for accurate results.
/// - If no value is provided, a default inset of zero will be applied.
///
/// Use this modifier when you want precise control over bottom padding that respects the device's safe area.
@MainActor
public struct SafeAreaBottomPadding: ViewModifier {
    @Environment(\.safeAreaInsets) private var insets: EdgeInsets

    public init() {}

    public func body(content: Content) -> some View {
        content.padding(.bottom, insets.bottom)
    }
}

// MARK: - Public API

public extension View {
    /// Applies bottom padding equal to the current safe area bottom inset.
    ///
    /// This ensures content near the bottom edge is not obscured by system UI (e.g., the home indicator).
    ///
    /// - Returns: A view with bottom padding matching the safe area bottom inset.
    @MainActor
    func safeAreaBottomPadding() -> some View {
        modifier(SafeAreaBottomPadding())
    }
}
