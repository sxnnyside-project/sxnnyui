//
//  CenterAlignedLabelStyle.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// A custom label style that aligns the label's icon and title in a horizontal stack.
/// The icon's size adjusts based on the user's accessibility settings.
public struct CenterAlignedLabelStyle: LabelStyle {
    /// The current size category from the environment, used to adjust the icon's size.
    @Environment(\.sizeCategory) var size
    
    /// Creates the body of the label style.
    /// - Parameter configuration: The configuration containing the label's icon and title.
    /// - Returns: A view that arranges the icon and title in a horizontal stack.
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if size >= .accessibilityMedium {
                configuration.icon
                    .frame(width: 80) // Larger icon size for accessibility.
            } else {
                configuration.icon
                    .frame(width: 30) // Default icon size.
            }
            configuration.title
        }
    }
}

extension LabelStyle where Self == CenterAlignedLabelStyle {
    /// A static property to easily access the `CenterAlignedLabelStyle`.
    public static var centerAligned: CenterAlignedLabelStyle { CenterAlignedLabelStyle() }
}
