//
//  RoundedBorderModifier.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// A view modifier that adds a rounded rectangle border to the modified view.
///
/// The `RoundedBorderModifier` overlays the view with a `RoundedRectangle` stroke of the specified color, width, and corner radius,
/// and then applies the same corner radius to the content to ensure clipping and consistent appearance.
///
/// - Parameters:
///   - color: The color of the border. Defaults to `.blue`.
///   - width: The width of the border line. Defaults to `2`.
///   - radius: The corner radius of the border. Defaults to `8`.
///
/// - Example:
/// ```swift
/// Text("Example")
///     .roundedBorder(color: .red, width: 3, radius: 12)
/// ```
///
/// This will display a `Text` view with a red border, 3 points wide, with 12-point corner radii.
@MainActor
private struct RoundedBorderModifier: ViewModifier {
    let color: Color
    let width: CGFloat
    let radius: CGFloat

    init(color: Color = .blue, width: CGFloat = 2, radius: CGFloat = 8) {
        self.color = color
        self.width = width
        self.radius = radius
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(color, lineWidth: width)
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

// MARK: - Public API

public extension View {
    /// Applies a rounded rectangle border to the view.
    ///
    /// - Parameters:
    ///   - color: The color of the border. Defaults to `.blue`.
    ///   - width: The width of the border line. Defaults to `2`.
    ///   - radius: The corner radius of the border. Defaults to `8`.
    /// - Returns: A view with the rounded border applied.
    @MainActor
    func roundedBorder(color: Color = .blue, width: CGFloat = 2, radius: CGFloat = 8) -> some View {
        modifier(RoundedBorderModifier(color: color, width: width, radius: radius))
    }
}
