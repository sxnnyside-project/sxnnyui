//
//  Badge.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// A SwiftUI view that represents a badge, which can display either a count or an image.
///
/// The `Badge` view is typically used to indicate notifications, counts, or statuses
/// by overlaying a small circular element on top of another view.
struct Badge: View {
    /// The count to display inside the badge. If `nil`, the badge will display an image instead.
    var count: Int?

    /// The name of the system image to display inside the badge. Used if `count` is `nil`.
    var imageName: String?

    /// The content and layout of the badge.
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 15, height: 15)

            if let count = count {
                Text("\(count)")
                    .foregroundColor(.white)
                    .font(.caption)
            } else if let imageName = imageName {
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
        .offset(x: 10, y: -10)
    }
}

/// A view modifier that overlays a badge on top of another view.
///
/// The `BadgeModifier` allows you to add a badge to any SwiftUI view by specifying
/// either a count or an image.
struct BadgeModifier: ViewModifier {
    /// The count to display inside the badge. If `nil`, the badge will display an image instead.
    var count: Int?

    /// The name of the system image to display inside the badge. Used if `count` is `nil`.
    var imageName: String?

    /// Modifies the content view by overlaying a badge.
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            if count != nil || imageName != nil {
                Badge(count: count, imageName: imageName)
            }
        }
    }
}

extension View {
    /// Adds a badge to the view.
    ///
    /// Use this method to overlay a badge on any SwiftUI view. The badge can display
    /// either a count or an image.
    ///
    /// - Parameters:
    ///   - count: The count to display inside the badge. If `nil`, the badge will display an image instead.
    ///   - imageName: The name of the system image to display inside the badge. Used if `count` is `nil`.
    /// - Returns: A view with the badge overlay.
    public func badge(count: Int? = nil, imageName: String? = nil) -> some View {
        self.modifier(BadgeModifier(count: count, imageName: imageName))
    }
}
