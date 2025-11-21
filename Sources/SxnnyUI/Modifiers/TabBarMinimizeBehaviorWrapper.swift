//
//  TabBarMinimizeBehaviorWrapper.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 27/08/25.
//

import SwiftUI

// MARK: - iOS-only implementation

#if os(iOS)
@MainActor
private struct TabBarMinimizeBehaviorWrapper: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            // Apply the behavior only when the API is available.
            // Note: Replace 16.0 with the correct minimum OS version that introduced this API.
            content.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            content
        }
    }
}
#else
// Non-iOS platforms: No-op modifier to keep API available cross-platform.
@MainActor
private struct TabBarMinimizeBehaviorWrapper: ViewModifier {
    func body(content: Content) -> some View { content }
}
#endif

// MARK: - Public API

public extension View {
    /// Conditionally applies `.tabBarMinimizeBehavior(.onScrollDown)` on supported iOS versions.
    ///
    /// - Behavior:
    ///   - On iOS where the API is available, the tab bar minimizes when scrolling down.
    ///   - On older iOS versions and non‑iOS platforms, this is a no‑op and returns `self`.
    @MainActor
    func tabBarMinimizeBehaviorWrapper() -> some View {
        self.modifier(TabBarMinimizeBehaviorWrapper())
    }
}
