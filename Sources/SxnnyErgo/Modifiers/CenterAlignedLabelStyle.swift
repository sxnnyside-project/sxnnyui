//
//  CenterAlignedLabelStyle.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - CenterAlignedLabelStyle
//
// `Label`'s default style doesn't scale its icon alongside Dynamic Type, so at large
// accessibility text sizes the icon becomes disproportionately small next to the title.
// This style scales the icon to match, as a native `LabelStyle` conformance.

/// A label style that horizontally aligns the icon and title, scaling the icon for
/// large accessibility text sizes.
///
/// ```swift
/// Label("Inbox", systemImage: "tray")
///     .labelStyle(.centerAligned)
/// ```
@MainActor
public struct CenterAlignedLabelStyle: LabelStyle {
    @Environment(\.sizeCategory) private var sizeCategory

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .frame(width: sizeCategory >= .accessibilityMedium ? 80 : 30)
            configuration.title
        }
    }
}

// MARK: - Static Accessor

extension LabelStyle where Self == CenterAlignedLabelStyle {
    /// A label style that horizontally aligns icon and title, scaling the icon for
    /// large accessibility text sizes.
    public static var centerAligned: CenterAlignedLabelStyle { CenterAlignedLabelStyle() }
}
