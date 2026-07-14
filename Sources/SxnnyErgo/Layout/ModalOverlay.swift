//
//  ModalOverlay.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

// MARK: - ModalOverlay
//
// Presents content above a dimmed backdrop with correct layering, entrance/exit
// transitions, and an accessible dismiss affordance — a small composition that's easy
// to get subtly wrong when rebuilt at every call site. Content is never size-constrained
// by the overlay itself; size it exactly as you would any other view.

/// A modal overlay that presents content above a dimmed, optionally dismissible backdrop.
///
/// Use `ModalOverlay` for custom dialogs, confirmation sheets, or lightweight modal
/// content that doesn't warrant a full `.sheet` presentation.
///
/// ```swift
/// @State private var isShowingConfirmation = false
///
/// ZStack {
///     content
///     ModalOverlay(isPresented: $isShowingConfirmation) {
///         VStack(spacing: 16) {
///             Text("Discard changes?")
///                 .font(.headline)
///             Button("Discard", role: .destructive) { discard() }
///             Button("Cancel") { isShowingConfirmation = false }
///         }
///         .padding(24)
///     }
/// }
/// ```
///
/// The overlay does not constrain the size of `content` — size it exactly as you would
/// any other view (`.frame(maxWidth:)`, `.padding()`, and so on).
public struct ModalOverlay<Content: View>: View {
    @Binding private var isPresented: Bool
    private let dismissesOnBackgroundTap: Bool
    private let backgroundMaterial: Material
    private let cornerRadius: CGFloat
    private let content: () -> Content

    /// Creates a modal overlay that presents `content` above a dimmed backdrop when
    /// `isPresented` is `true`.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that shows or hides the overlay.
    ///   - dismissesOnBackgroundTap: Whether tapping the dimmed backdrop dismisses the
    ///     overlay. Defaults to `true`. Set to `false` for content that requires an
    ///     explicit in-content action to dismiss (e.g., a mandatory confirmation).
    ///   - backgroundMaterial: The material behind `content`. Defaults to `.regularMaterial`.
    ///   - cornerRadius: The corner radius applied to `content`'s background. Defaults to `16`.
    ///   - content: A view builder providing the overlay's content. `ModalOverlay` does
    ///     not constrain its size.
    public init(
        isPresented: Binding<Bool>,
        dismissesOnBackgroundTap: Bool = true,
        backgroundMaterial: Material = .regularMaterial,
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.dismissesOnBackgroundTap = dismissesOnBackgroundTap
        self.backgroundMaterial = backgroundMaterial
        self.cornerRadius = cornerRadius
        self.content = content
    }

    public var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(Text("Dismiss"))
                    .onTapGesture {
                        guard dismissesOnBackgroundTap else { return }
                        withAnimation { isPresented = false }
                    }

                content()
                    .background(
                        backgroundMaterial,
                        in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    )
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}
