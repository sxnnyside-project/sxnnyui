//
//  Badge.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines the `Badge` view and a corresponding `View` modifier for overlaying
//  notification badges on any SwiftUI view. The implementation follows Swift package best
//  practices and includes clear, actionable documentation throughout.
//
//  Example usage:
//  ```swift
//  Image(systemName: "bell")
//      .badge(count: 5)
//  Image(systemName: "person")
//      .badge(imageName: "exclamationmark.triangle")
//  ```
//

import SwiftUI

// MARK: - Badge

/// A small badge for counts or status, typically overlaid on another view.
///
/// The `Badge` view displays either a count or an SF Symbol, and is commonly used to indicate
/// notifications, statuses, or similar discrete information. It is visually styled as a red circle
/// with white content.
///
/// Example usage:
/// ```swift
/// Badge(count: 3)
/// Badge(imageName: "star.fill")
/// ```
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public struct Badge: View {
    /// The count to display. If `nil`, displays an image instead.
    public let count: Int?

    /// The SF Symbol name to display, used when `count` is `nil`.
    public let imageName: String?

    /// Creates a badge displaying a count or image.
    /// - Parameters:
    ///   - count: The value to display, or `nil` to display an image.
    ///   - imageName: The SF Symbol to display if `count` is `nil`.
    public init(count: Int? = nil, imageName: String? = nil) {
        self.count = count
        self.imageName = imageName
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 15, height: 15)
            if let count {
                Text("\(count)")
                    .foregroundColor(.white)
                    .font(.caption)
            } else if let imageName {
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
        .offset(x: 10, y: -10)
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

/// A view modifier that overlays a `Badge` at the top trailing edge of a view.
///
/// Use the `.badge(count:imageName:)` extension for a convenient API.
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
private struct BadgeModifier: ViewModifier {
    /// The count to display inside the badge. If `nil`, shows an image.
    let count: Int?
    /// The SF Symbol name to display when `count` is `nil`.
    let imageName: String?

    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            if count != nil || imageName != nil {
                Badge(count: count, imageName: imageName)
            }
        }
    }
}

// MARK: - Public API

public extension View {
    /// Overlays a badge at the top trailing edge of the view.
    ///
    /// Use this modifier to show notification counts or statuses by overlaying a badge
    /// on any SwiftUI view.
    ///
    /// Example usage:
    /// ```swift
    /// Image(systemName: "envelope")
    ///     .badge(count: 2)
    /// Image(systemName: "person.crop.circle")
    ///     .badge(imageName: "star.fill")
    /// ```
    ///
    /// - Parameters:
    ///   - count: The count to display. If `nil`, shows an image.
    ///   - imageName: The SF Symbol name to show if `count` is `nil`.
    /// - Returns: The modified view with a badge overlay.
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    func badge(count: Int? = nil, imageName: String? = nil) -> some View {
        self.modifier(BadgeModifier(count: count, imageName: imageName))
    }
}
