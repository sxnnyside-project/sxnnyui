//
//  FocusText.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 15/01/25.
//
//  This file defines a stylable SwiftUI view for displaying text or custom content
//  with customizable background, corner radius, shadow, and padding. 
//  APIs are documented and guarded for cross-platform, Swift package compatibility.
//

import SwiftUI

/// A customizable SwiftUI view for styled text or content with background, corner, shadow, and padding.
///
/// Use `FocusText` to display a `Text` or any custom view with common styling options. 
/// All styles are builder-chainable for succinct configuration.
///
/// Example usage:
/// ```swift
/// FocusText("Focus!")
///     .backgroundColor(.accentColor)
///     .foregroundColor(.white)
///     .cornerRadius(10)
///     .shadowColor(.gray)
///     .shadowRadius(5)
///     .padding(8)
/// ```
///
/// - Important: Uses `.foregroundStyle` if available (macOS 12+/iOS 15+); falls back to `.foregroundColor` on earlier systems.
/// - Note: All style modifiers return a new `FocusText`, allowing chained configuration.
///
@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@MainActor
public struct FocusText<Content: View>: View {
    // MARK: - Properties

    /// The content to display (typically `Text` or custom view).
    let content: Content

    /// The background color.
    var backgroundColor: Color = .accentColor

    /// The foreground (text/content) color.
    var foregroundColor: Color = .white

    /// The corner radius.
    var cornerRadius: CGFloat = 10

    /// The shadow color.
    var shadowColor: Color = .gray

    /// The shadow radius.
    var shadowRadius: CGFloat = 5

    /// The content padding.
    var padding: CGFloat = 8

    // MARK: - Initialization

    /// Creates a `FocusText` view with a string.
    ///
    /// - Parameter text: The text to display.
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }

    /// Creates a `FocusText` view with custom content.
    ///
    /// - Parameter content: A closure providing the custom content.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - View

    /// The content and styling for this view.
    public var body: some View {
        Group {
            if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                content
                    .padding(padding)
                    .foregroundStyle(foregroundColor)
            } else {
                content
                    .padding(padding)
                    .foregroundColor(foregroundColor)
            }
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 5)
    }
}

// MARK: - Modifiers

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public extension FocusText {
    /// Sets the background color.
    /// - Parameter color: The background color.
    /// - Returns: A new `FocusText` with this background.
    func backgroundColor(_ color: Color) -> FocusText {
        var copy = self
        copy.backgroundColor = color
        return copy
    }

    /// Sets the foreground (text/content) color.
    /// - Parameter color: The foreground color.
    /// - Returns: A new `FocusText` with this color.
    func foregroundColor(_ color: Color) -> FocusText {
        var copy = self
        copy.foregroundColor = color
        return copy
    }

    /// Sets the corner radius.
    /// - Parameter radius: The corner radius.
    /// - Returns: A new `FocusText` with this radius.
    func cornerRadius(_ radius: CGFloat) -> FocusText {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }

    /// Sets the shadow color.
    /// - Parameter color: The shadow color.
    /// - Returns: A new `FocusText` with this shadow color.
    func shadowColor(_ color: Color) -> FocusText {
        var copy = self
        copy.shadowColor = color
        return copy
    }

    /// Sets the shadow radius.
    /// - Parameter radius: The shadow radius.
    /// - Returns: A new `FocusText` with this shadow radius.
    func shadowRadius(_ radius: CGFloat) -> FocusText {
        var copy = self
        copy.shadowRadius = radius
        return copy
    }

    /// Sets the content padding.
    /// - Parameter value: The padding value.
    /// - Returns: A new `FocusText` with this padding.
    func padding(_ value: CGFloat) -> FocusText {
        var copy = self
        copy.padding = value
        return copy
    }
}
