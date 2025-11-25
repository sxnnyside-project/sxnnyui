//
//  CenterAlignedLabelStyle.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines a custom label style for aligning icons and titles in a horizontal stack, with accessibility-aware sizing.
//  All APIs are documented and guarded for platform compatibility, following Swift package distribution best practices.
//
//  Example usage:
//  ```swift
//  if #available(iOS 14.0, macOS 11.0, *) {
//      Label("Profile", systemImage: "person.circle")
//          .labelStyle(.centerAligned)
//  }
//  ```
//

import SwiftUI

// MARK: - CenterAlignedLabelStyle

/// A custom label style that horizontally aligns the icon and title, scaling the icon for accessibility.
///
/// The icon size adapts for users with larger accessibility settings. Use this style
/// to improve clarity for users who increase font or interface sizes.
///
/// > Requires: iOS 14.0+ or macOS 11.0+
///
/// ### Example
/// ```swift
/// Label("Inbox", systemImage: "tray")
///     .labelStyle(.centerAligned)
/// ```
///
/// - Tag: CenterAlignedLabelStyle
@available(iOS 14.0, macOS 11.0, *)
@MainActor
public struct CenterAlignedLabelStyle: LabelStyle {
    /// The current size category from the environment, used to adjust the icon's size.
    @Environment(\.sizeCategory) private var sizeCategory

    /// Arranges the icon and title in a horizontal stack, scaling the icon for accessibility.
    /// - Parameter configuration: The label's icon and title.
    /// - Returns: A horizontally arranged icon and title.
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            if sizeCategory >= .accessibilityMedium {
                configuration.icon
                    .frame(width: 80) // Larger icon for accessibility.
            } else {
                configuration.icon
                    .frame(width: 30) // Default icon size.
            }
            configuration.title
        }
    }
}

// MARK: - Public API

@available(iOS 14.0, macOS 11.0, *)
public extension LabelStyle where Self == CenterAlignedLabelStyle {
    /// A static property for easy use of the center-aligned label style.
    static var centerAligned: CenterAlignedLabelStyle { CenterAlignedLabelStyle() }
}

// MARK: - No-op fallback for earlier platforms

#if !os(iOS) && !os(macOS)
/// No-op fallback for platforms without LabelStyle (e.g., watchOS before 7.0, etc.).
@MainActor
public struct CenterAlignedLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}
#endif
