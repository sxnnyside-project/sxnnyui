//
//  SxnnyScaffold.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file provides `SxnnyScaffold`, a structural container view that arranges
//  a top bar, bottom bar, floating action button (FAB), and main content in a
//  consistent layout. This pattern is similar to the Scaffold pattern found in
//  Jetpack Compose, facilitating standardized and adaptive screen layouts.
//
//  Usage Example:
//    SxnnyScaffold(
//        topBar: { MyTopBar() },
//        bottomBar: { MyBottomBar() },
//        floatingActionButton: { MyFAB() }
//    ) {
//        MainContentView()
//    }
//

import SwiftUI

// MARK: - SxnnyScaffold

/// A structural container that arranges a top bar, main content, bottom bar, and optional floating action button (FAB).
///
/// Use `SxnnyScaffold` to standardize screen layouts across your app, providing consistent placement of navigation bars,
/// bottom bars, floating buttons, and content. This is inspired by the Scaffold pattern in Jetpack Compose.
///
/// Example:
/// ```swift
/// SxnnyScaffold(
///     topBar: { CustomTopBar() },
///     bottomBar: { CustomBottomBar() },
///     floatingActionButton: { CustomFAB() }
/// ) {
///     MainContentView()
/// }
/// ```
public struct SxnnyScaffold<
    Content: View,
    TopBar: View,
    BottomBar: View,
    FloatingActionButton: View
>: View {

    /// The main content of the scaffold.
    private let content: Content
    /// The view displayed at the top (e.g., navigation bar).
    private let topBar: TopBar
    /// The view displayed at the bottom (e.g., tab bar).
    private let bottomBar: BottomBar
    /// The floating action button view.
    private let floatingActionButton: FloatingActionButton
    /// The background color of the scaffold.
    private let backgroundColor: Color
    /// Whether to use safe area for the content.
    private let useSafeArea: Bool

    /// Creates a scaffold layout with customizable bars, content, and floating action button.
    ///
    /// - Parameters:
    ///   - useSafeArea: Whether the content should respect the safe area. Defaults to `true`.
    ///   - backgroundColor: The background color of the scaffold. Defaults to `SxnnyTheme.background`.
    ///   - topBar: A view builder for the top bar (optional; defaults to empty).
    ///   - bottomBar: A view builder for the bottom bar (optional; defaults to empty).
    ///   - floatingActionButton: A view builder for the floating action button (optional; defaults to empty).
    ///   - content: A view builder for the main content.
    public init(
        useSafeArea: Bool = true,
        backgroundColor: Color = SxnnyTheme.background,
        @ViewBuilder topBar: () -> TopBar = { EmptyView() },
        @ViewBuilder bottomBar: () -> BottomBar = { EmptyView() },
        @ViewBuilder floatingActionButton: () -> FloatingActionButton = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) {
        self.useSafeArea = useSafeArea
        self.backgroundColor = backgroundColor
        self.topBar = topBar()
        self.bottomBar = bottomBar()
        self.floatingActionButton = floatingActionButton()
        self.content = content()
    }

    /// The body of the scaffold, arranging the bars, content, and FAB as specified.
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background
            Group {
                if #available(macOS 11.0, *) {
                    backgroundColor
                        .ignoresSafeArea()
                } else {
                    backgroundColor
                }
            }

            // Main layout
            VStack(spacing: 0) {
                topBar
                if useSafeArea {
                    content
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .modifier(SafeAreaBottomPadding())
                } else {
                    content
                }
                bottomBar
            }

            // Floating action button
            floatingActionButton
                .padding()
        }
    }
}
