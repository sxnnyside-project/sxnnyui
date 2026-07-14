//
//  Geometry.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 14/07/26.
//
//  This file provides the canonical, dependency-free way to read a view's rendered
//  size and frame. SwiftUI has no built-in API for this; the usual workaround —
//  a `GeometryReader` wrapped in `.background`, paired with a `PreferenceKey` — is
//  reimplemented ad hoc in nearly every SwiftUI codebase. `readSize(_:)` and
//  `readFrame(in:_:)` package that boilerplate once, correctly.
//

import SwiftUI

// MARK: - Size Reading

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    /// Observes the view's rendered size without affecting its layout.
    ///
    /// `GeometryReader` is greedy — it expands to fill all the space offered to it,
    /// which disrupts the layout of anything it wraps directly. `readSize(_:)` avoids
    /// this by placing the `GeometryReader` inside a `.background`, so it measures the
    /// content without influencing how the content itself is sized.
    ///
    /// `action` is called once when the view first appears and again whenever the size
    /// changes; consecutive identical sizes are not reported twice.
    ///
    /// ```swift
    /// Text("Hello, world!")
    ///     .readSize { size in
    ///         print("Rendered size: \(size)")
    ///     }
    /// ```
    ///
    /// - Parameter action: A closure called with the view's current size.
    /// - Returns: A view that reports its size without changing its own layout.
    @MainActor
    public func readSize(_ action: @escaping @MainActor (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { size in
            action(size)
        }
    }

    /// Observes the view's frame in the given coordinate space without affecting its layout.
    ///
    /// Like `readSize(_:)`, this reads geometry via a `GeometryReader` tucked inside a
    /// `.background`, so the parent's layout of this view is unaffected. `action` is called
    /// once on initial appearance and again whenever the frame changes; consecutive
    /// identical frames are not reported twice.
    ///
    /// ```swift
    /// Text("Hello, world!")
    ///     .readFrame(in: .named("container")) { frame in
    ///         print("Frame in container: \(frame)")
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - coordinateSpace: The coordinate space to measure the frame in. Defaults to `.global`.
    ///   - action: A closure called with the view's current frame.
    /// - Returns: A view that reports its frame without changing its own layout.
    @MainActor
    public func readFrame(
        in coordinateSpace: CoordinateSpace = .global,
        _ action: @escaping @MainActor (CGRect) -> Void
    ) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: proxy.frame(in: coordinateSpace))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self) { frame in
            action(frame)
        }
    }
}
