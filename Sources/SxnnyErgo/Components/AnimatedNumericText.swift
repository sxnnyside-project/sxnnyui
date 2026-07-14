//
//  AnimatedNumericText.swift
//  SxnnyErgo
//

import SwiftUI

// MARK: - AnimatedNumericText

/// Displays a numeric value as `Text`, animating digit-by-digit whenever the value changes.
///
/// Wraps SwiftUI's `.contentTransition(.numericText())` together with the `withAnimation` call
/// it needs around the value change — the two have to be wired up together or the transition
/// never actually animates.
///
/// ```swift
/// struct ScoreView: View {
///     @State private var score = 0
///
///     var body: some View {
///         VStack {
///             AnimatedNumericText(value: score)
///             Button("Add 10") {
///                 score += 10
///             }
///         }
///     }
/// }
/// ```
///
/// - Note: Requires the `.numericText(value:)` content transition, available starting
///   iOS 17, macOS 14, tvOS 17, and watchOS 10.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AnimatedNumericText: View {
    private let value: Double
    private let format: FloatingPointFormatStyle<Double>
    private let animation: Animation

    // MARK: Initializers

    /// Creates an animated numeric text view.
    ///
    /// - Parameters:
    ///   - value: The numeric value to display.
    ///   - format: The format style used to render `value`. Defaults to `.number`.
    ///   - animation: The animation used when `value` changes. Defaults to `.default`.
    public init(
        value: Double,
        format: FloatingPointFormatStyle<Double> = .number,
        animation: Animation = .default
    ) {
        self.value = value
        self.format = format
        self.animation = animation
    }

    /// Creates an animated numeric text view from an integer value.
    ///
    /// - Parameters:
    ///   - value: The integer value to display.
    ///   - animation: The animation used when `value` changes. Defaults to `.default`.
    public init(value: Int, animation: Animation = .default) {
        self.init(value: Double(value), format: .number.precision(.fractionLength(0)), animation: animation)
    }

    // MARK: Body

    public var body: some View {
        Text(value, format: format)
            .contentTransition(.numericText(value: value))
            .animation(animation, value: value)
    }
}
