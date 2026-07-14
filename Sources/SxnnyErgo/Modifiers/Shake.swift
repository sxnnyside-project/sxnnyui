//
//  Shake.swift
//  SxnnyErgo
//

import SwiftUI

// MARK: - Shake Effect

extension View {

    // MARK: Trigger

    /// Plays a short horizontal shake, replayed each time `trigger` changes.
    ///
    /// The classic use is flagging invalid input: change `trigger` (for example by
    /// incrementing a counter) whenever validation fails, and the field shakes to draw
    /// attention without any other state management.
    ///
    /// ```swift
    /// struct LoginForm: View {
    ///     @State private var password = ""
    ///     @State private var shakeCount = 0
    ///
    ///     var body: some View {
    ///         SecureField("Password", text: $password)
    ///             .shake(trigger: shakeCount)
    ///             .onSubmit {
    ///                 if !isValid(password) { shakeCount += 1 }
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// When Reduce Motion is enabled, the shake is skipped entirely and the view is left
    /// unaltered, since the effect is purely decorative.
    ///
    /// - Parameter trigger: A value whose changes replay the shake. Any `Equatable` value works;
    ///   incrementing an integer counter is the common pattern.
    /// - Returns: A view that shakes horizontally whenever `trigger` changes.
    @inlinable
    public func shake(trigger: some Equatable) -> some View {
        modifier(ShakeModifier(trigger: trigger))
    }
}

// MARK: - Modifier (usable from inlinable)

@usableFromInline
struct ShakeModifier<Trigger: Equatable>: ViewModifier {
    @usableFromInline let trigger: Trigger
    @Environment(\.accessibilityReduceMotion) @usableFromInline var reduceMotion
    @State @usableFromInline var animatableProgress: CGFloat = 0

    @usableFromInline
    init(trigger: Trigger) {
        self.trigger = trigger
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content
            .modifier(ShakeGeometryEffect(progress: animatableProgress))
            .onChange(of: trigger) { _ in
                guard !reduceMotion else { return }
                animatableProgress = 0
                withAnimation(.linear(duration: 0.4)) {
                    animatableProgress = 1
                }
            }
    }
}

// MARK: - Geometry Effect (usable from inlinable)

/// Oscillates its content horizontally as `progress` animates from `0` to `1`.
@usableFromInline
struct ShakeGeometryEffect: GeometryEffect {
    @usableFromInline var progress: CGFloat

    @usableFromInline
    init(progress: CGFloat) {
        self.progress = progress
    }

    @usableFromInline
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    @usableFromInline
    func effectValue(size: CGSize) -> ProjectionTransform {
        let amplitude: CGFloat = 8
        let oscillations: CGFloat = 3
        let offsetX = amplitude * sin(progress * .pi * oscillations) * (1 - progress)
        return ProjectionTransform(CGAffineTransform(translationX: offsetX, y: 0))
    }
}
