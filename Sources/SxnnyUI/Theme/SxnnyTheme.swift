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
///
/// ## Topics
///
/// ### Colors
/// - ``background``
/// - ``primary``
/// - ``accentColor``
///
/// ### Layout
/// - ``defaultSpacing``
/// - ``defaultPadding``
/// - ``cornerRadius``
public struct SxnnyTheme: Sendable {
    // MARK: - Colors

    /// The default background color, matching the system background.
    ///
    /// On iOS, tvOS, and visionOS, this uses `UIColor.systemBackground`.
    /// On macOS, this uses `NSColor.windowBackgroundColor`.
    /// On watchOS, this uses a neutral black color suitable for OLED displays.
    #if canImport(UIKit) && !os(watchOS)
    public static let background: Color = Color(.systemBackground)
    #elseif os(watchOS)
    public static let background: Color = Color.black
    #elseif canImport(AppKit)
    public static let background: Color = Color(NSColor.windowBackgroundColor)
    #else
    public static let background: Color = Color(.sRGB, white: 0.1, opacity: 1)
    #endif

    /// The primary brand color, used for key elements and emphasis.
    public static let primary: Color = Color(hex: "#FFB700")

    /// The accent color, typically used for interactive elements or highlights.
    public static let accentColor: Color = Color(hex: "#FFB700")

    // MARK: - Layout

    /// The standard spacing value for layout margins and gaps between UI elements.
    public static let defaultSpacing: CGFloat = 12

    /// The standard padding value for component content insets.
    public static let defaultPadding: CGFloat = 12

    /// The standard corner radius for rounded UI components.
    public static let cornerRadius: CGFloat = 12

    // MARK: - Initialization

    /// Private initializer to prevent instantiation.
    private init() {}
}
