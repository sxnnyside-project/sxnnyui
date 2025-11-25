//
//  SxnnyTheme.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

/// `SxnnyTheme` provides a centralized set of visual constants for the SxnnyUI design system.
///
/// Use these static properties to maintain a consistent look and feel throughout your user interface components.
/// - `background`: The default background color, matching the system background.
/// - `primary`: The primary brand color, used for key elements and emphasis.
/// - `accentColor`: The accent color, typically used for interactive elements or highlights.
/// - `defaultSpacing`: The standard spacing value for layout margins and gaps between UI elements.
/// - `defaultPadding`: The standard padding value for component content insets.
/// - `cornerRadius`: The standard corner radius for rounded UI components.
public struct SxnnyTheme {
    #if canImport(UIKit) && !os(watchOS)
    public static let background: Color = Color(.systemBackground)
    #else
    public static let background: Color = Color(NSColor.windowBackgroundColor)
    #endif
    public static let primary: Color = Color(hex: "#FFB700")
    public static let accentColor: Color = Color(hex: "#FFB700")
    public static let defaultSpacing: CGFloat = 12
    public static let defaultPadding: CGFloat = 12
    public static let cornerRadius: CGFloat = 12
}
