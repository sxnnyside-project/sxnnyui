//
//  SxnnyStackSpacer.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//
//  This file defines `SxnnyStackSpacer`, an enhanced spacer view for SwiftUI stacks
//  with optional min/max sizing and optional animation for dynamic layouts.
//
//  Usage Example:
//    SxnnyStackSpacer(minLength: 8, maxLength: 32, animated: true)
//

import SwiftUI

// MARK: - SxnnyStackSpacer

/// A flexible spacer for use in SwiftUI stacks, supporting minimum and maximum length constraints
/// and optional animation for layout changes.
///
/// Use `SxnnyStackSpacer` to introduce flexible spacing with more control than the standard `Spacer`,
/// such as animating size changes or constraining minimum and maximum spacer sizes.
///
/// Example:
/// ```swift
/// HStack {
///     Text("Left")
///     SxnnyStackSpacer(minLength: 16, maxLength: 64, animated: true)
///     Text("Right")
/// }
/// ```
public struct SxnnyStackSpacer: View {
    /// The minimum length for the spacer, if any.
    private let minLength: CGFloat?
    /// The maximum length for the spacer, if any.
    private let maxLength: CGFloat?
    /// Whether to animate layout changes affecting the spacer.
    private let animated: Bool

    /// Creates a flexible, optionally animated spacer.
    ///
    /// - Parameters:
    ///   - minLength: The minimum spacer size. Defaults to `nil`.
    ///   - maxLength: The maximum spacer size. Defaults to `nil`.
    ///   - animated: Whether to animate layout changes affecting the spacer. Defaults to `false`.
    public init(
        minLength: CGFloat? = nil,
        maxLength: CGFloat? = nil,
        animated: Bool = false
    ) {
        self.minLength = minLength
        self.maxLength = maxLength
        self.animated = animated
    }

    /// The view’s body, providing a flexible spacer with optional animation and constraints.
    public var body: some View {
        Spacer(minLength: minLength)
            .frame(minHeight: minLength, maxHeight: maxLength)
            .animation(animated ? .default : nil, value: UUID())
    }
}
