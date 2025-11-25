//
//  SxnnyOverlay.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file provides `SxnnyOverlay`, a reusable SwiftUI view for modal overlays.
//  It displays custom content above a dimmed background and supports smooth animated
//  presentation and dismissal. Tapping outside the content automatically dismisses
//  the overlay. Designed for alerts, dialogs, or custom modals.
//
//  Usage Example:
//    SxnnyOverlay(isPresented: $showDialog) {
//        Text("Hello from a modal!")
//    }
//

import SwiftUI

// MARK: - SxnnyOverlay

/// A reusable overlay that presents custom content above a dimmed background.
/// The overlay appears with animation and is dismissed by tapping outside its content.
///
/// Use `SxnnyOverlay` for custom dialogs, alerts, or modal presentations.
///
/// Example:
/// ```swift
/// SxnnyOverlay(isPresented: $isModalShown) {
///     VStack {
///         Text("Modal Content")
///         Button("Close") { isModalShown = false }
///     }
/// }
/// ```
public struct SxnnyOverlay<Content: View>: View {
    /// Controls whether the overlay is presented.
    @Binding private var isPresented: Bool
    /// The content displayed in the modal overlay.
    private let content: () -> Content

    /// Creates a modal overlay that presents custom content when `isPresented` is `true`.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that shows or hides the overlay.
    ///   - content: A view builder providing the overlay’s content.
    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.content = content
    }

    /// The body of the overlay view.
    /// Renders a dimmed background and centers the custom content with smooth animations.
    public var body: some View {
        GeometryReader { geo in
            if isPresented {
                ZStack {
                    // Dimmed dismissible background.
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isPresented = false
                            }
                        }

                    // Centered modal content.
                    content()
                        .frame(maxWidth: geo.size.width * 0.8,
                               maxHeight: geo.size.height * 0.5)
                        .background(SxnnyTheme.background)
                        .cornerRadius(16)
                        .shadow(radius: 20)
                        .transition(.scale.combined(with: .opacity))
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}
