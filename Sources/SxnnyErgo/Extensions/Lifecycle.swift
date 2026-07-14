//
//  Lifecycle.swift
//  SxnnyErgo
//

import SwiftUI

// MARK: - View Lifecycle

extension View {

    // MARK: First Appearance

    /// Runs `action` exactly once for the lifetime of the view's identity, no matter how
    /// many times `.onAppear` would otherwise fire.
    ///
    /// SwiftUI calls `.onAppear` every time a view re-enters the hierarchy — for example each
    /// time a `TabView` tab is revisited, or a view is scrolled back into a `List`. `onFirstAppear`
    /// guards against that by tracking whether it has already fired with a small piece of
    /// `@State`, so the action only ever runs on the true first appearance.
    ///
    /// ```swift
    /// struct ProfileTab: View {
    ///     var body: some View {
    ///         ProfileView()
    ///             .onFirstAppear {
    ///                 Analytics.log("profile_tab_first_shown")
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter action: The closure to run on the view's first appearance.
    /// - Returns: A view that invokes `action` once, on first appearance.
    @inlinable
    public func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
}

// MARK: - Modifier (usable from inlinable)

@usableFromInline
struct OnFirstAppearModifier: ViewModifier {
    @usableFromInline let action: () -> Void
    @State @usableFromInline var hasAppeared = false

    @usableFromInline
    init(action: @escaping () -> Void) {
        self.action = action
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
