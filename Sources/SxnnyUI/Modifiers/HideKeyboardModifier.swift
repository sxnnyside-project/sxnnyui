//
//  HideKeyboardModifier.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - UIKit-backed implementations (iOS, iPadOS, visionOS, tvOS where UIKit exists)
#if canImport(UIKit) && !os(watchOS)
import UIKit

/// A view modifier that hides the keyboard when tapping outside of input fields.
/// - Note: Only effective on platforms where UIKit is available.
@MainActor
private struct HideKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            // Ensure the entire area is tappable
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil, from: nil, for: nil)
            }
    }
}

/// A SwiftUI-compatible view that observes keyboard visibility changes using UIKit notifications.
@MainActor
private struct KeyboardVisibilityView: UIViewRepresentable {
    let onChange: @Sendable (Bool) -> Void

    final class ObserverBox {
        var willShow: NSObjectProtocol?
        var willHide: NSObjectProtocol?

        deinit {
            let center = NotificationCenter.default
            if let willShow { center.removeObserver(willShow) }
            if let willHide { center.removeObserver(willHide) }
        }
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let center = NotificationCenter.default
        let box = ObserverBox()

        box.willShow = center.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                          object: nil, queue: .main) { [onChange] _ in
            onChange(true)
        }

        box.willHide = center.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                          object: nil, queue: .main) { [onChange] _ in
            onChange(false)
        }

        // Associate the observer box with the view to keep it alive for the view's lifetime
        objc_setAssociatedObject(view, Unmanaged.passUnretained(self as AnyObject).toOpaque(), box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#else

// MARK: - Non-UIKit platforms (macOS AppKit, watchOS, etc.)

/// No-op modifier on platforms without UIKit.
@MainActor
private struct HideKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View { content }
}

/// No-op background observer on platforms without UIKit.
@MainActor
private struct KeyboardVisibilityView: View {
    let onChange: @Sendable (Bool) -> Void
    var body: some View { Color.clear.accessibilityHidden(true) }
}

#endif

// MARK: - Public API

public extension View {
    /// Hides the keyboard when tapping outside of input fields.
    ///
    /// On non-UIKit platforms, this is a no-op and returns `self`.
    @MainActor
    func hideKeyboardWhenTappedAround() -> some View {
        self.modifier(HideKeyboardModifier())
    }

    /// Programmatically dismisses the keyboard if it is currently displayed.
    ///
    /// On non-UIKit platforms, this is a no-op.
    @MainActor
    func hideKeyboard() {
        #if canImport(UIKit) && !os(watchOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
        #else
        // No-op on platforms without UIKit
        #endif
    }

    /// Adds an action to perform when the keyboard appears or disappears.
    ///
    /// - Parameter action: Receives `true` when the keyboard appears and `false` when it hides.
    /// On non-UIKit platforms, the action is never called.
    @MainActor
    func onKeyboardVisibilityChange(perform action: @Sendable @escaping (Bool) -> Void) -> some View {
        #if canImport(UIKit) && !os(watchOS)
        return self.background(KeyboardVisibilityView(onChange: action))
        #else
        return self.background(KeyboardVisibilityView(onChange: action))
        #endif
    }
}
