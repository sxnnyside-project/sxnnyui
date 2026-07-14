//
//  Badge.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - Badge
//
// Positions a correctly-accessible notification counter or status dot on an arbitrary
// view — offset math, hit-testing, and accessibility labeling handled consistently.
// SwiftUI's own `.badge()` modifier only attaches to `List` rows and `TabItem`s; this
// fills the gap for arbitrary views.

/// A small badge for counts or status, typically overlaid on another view via
/// `.badge(count:imageName:)`.
///
/// ```swift
/// Badge(count: 3)
/// Badge(imageName: "star.fill")
/// Badge(count: 12, color: .blue, diameter: 18)
/// ```
public struct Badge: View {
    /// The count to display. If `nil`, displays `imageName` instead.
    public let count: Int?
    /// The SF Symbol name to display, used when `count` is `nil`.
    public let imageName: String?
    /// The badge's fill color. Defaults to `.red`.
    public let color: Color
    /// The badge's diameter. Defaults to `15`.
    public let diameter: CGFloat

    /// Creates a badge displaying a count or an image.
    ///
    /// - Parameters:
    ///   - count: The value to display, or `nil` to display `imageName`.
    ///   - imageName: The SF Symbol to display when `count` is `nil`.
    ///   - color: The badge's fill color. Defaults to `.red`.
    ///   - diameter: The badge's diameter. Defaults to `15`.
    public init(count: Int? = nil, imageName: String? = nil, color: Color = .red, diameter: CGFloat = 15) {
        self.count = count
        self.imageName = imageName
        self.color = color
        self.diameter = diameter
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: diameter, height: diameter)
            if let count {
                Text("\(count)")
                    .foregroundStyle(.white)
                    .font(.caption)
            } else if let imageName {
                Image(systemName: imageName)
                    .foregroundStyle(.white)
                    .font(.caption)
            }
        }
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        if let count {
            return "\(count) notifications"
        } else if let imageName {
            return "Badge: \(imageName)"
        } else {
            return "Badge"
        }
    }
}

// MARK: - Badge Modifier

private struct BadgeModifier: ViewModifier {
    let count: Int?
    let imageName: String?
    let color: Color
    let diameter: CGFloat
    let alignment: Alignment

    func body(content: Content) -> some View {
        content.overlay(alignment: alignment) {
            if count != nil || imageName != nil {
                Badge(count: count, imageName: imageName, color: color, diameter: diameter)
                    .offset(x: diameter * 0.67, y: -diameter * 0.67)
            }
        }
    }
}

// MARK: - Public API

extension View {
    /// Overlays a badge on this view.
    ///
    /// ```swift
    /// Image(systemName: "envelope")
    ///     .badge(count: 2)
    ///
    /// Image(systemName: "person.crop.circle")
    ///     .badge(imageName: "star.fill", color: .blue)
    /// ```
    ///
    /// - Parameters:
    ///   - count: The count to display. If `nil`, shows `imageName` instead.
    ///   - imageName: The SF Symbol name to show when `count` is `nil`.
    ///   - color: The badge's fill color. Defaults to `.red`.
    ///   - diameter: The badge's diameter. Defaults to `15`.
    ///   - alignment: Where the badge is anchored on this view. Defaults to `.topTrailing`.
    /// - Returns: A view with a badge overlay.
    public func badge(
        count: Int? = nil,
        imageName: String? = nil,
        color: Color = .red,
        diameter: CGFloat = 15,
        alignment: Alignment = .topTrailing
    ) -> some View {
        self.modifier(
            BadgeModifier(count: count, imageName: imageName, color: color, diameter: diameter, alignment: alignment))
    }
}
