//
//  FocusText.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 15/01/25.
//

import SwiftUI

/// A customizable view that displays content with a styled background, corner radius, shadow, and padding.
/// This view is flexible and can display either a `Text` or custom content.
@available(iOS 13.0, *)
public struct FocusText<Content: View>: View {
    /// The content of the view, which can be a `Text` or any custom view.
    let content: Content
    /// The background color of the view.
    var backgroundColor: Color = .accentColor
    /// The foreground color of the view.
    var foregroundColor: Color = .white
    /// The corner radius of the view.
    var cornerRadius: CGFloat = 10
    /// The shadow color of the view.
    var shadowColor: Color = .gray
    /// The shadow radius of the view.
    var shadowRadius: CGFloat = 5
    /// The padding around the content.
    var padding: CGFloat = 8

    /// Initializes a `FocusText` with a `Text` content.
    /// - Parameter text: The text to display in the view.
    public init(_ text: String) where Content == Text {
        self.content = Text(text)
    }
    
    /// Initializes a `FocusText` with custom content.
    /// - Parameter content: A closure that provides the custom content for the view.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// The body of the `FocusText` view.
    /// Displays the content with the specified styles applied.
    public var body: some View {
        content
            .padding(padding)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 5)
    }
}

extension FocusText {
    /// Sets the background color of the `FocusText`.
    /// - Parameter color: The color to use as the background.
    /// - Returns: A new `FocusText` with the updated background color.
    public func backgroundColor(_ color: Color) -> FocusText {
        var copy = self
        copy.backgroundColor = color
        return copy
    }
    
    /// Sets the foreground color of the `FocusText`.
    /// - Parameter color: The color to use for the text.
    /// - Returns: A new `FocusText` with the updated foreground color.
    public func foregroundColor(_ color: Color) -> FocusText {
        var copy = self
        copy.foregroundColor = color
        return copy
    }

    /// Sets the corner radius of the `FocusText`.
    /// - Parameter radius: The corner radius to apply.
    /// - Returns: A new `FocusText` with the updated corner radius.
    public func cornerRadius(_ radius: CGFloat) -> FocusText {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }

    /// Sets the shadow color of the `FocusText`.
    /// - Parameter color: The color to use for the shadow.
    /// - Returns: A new `FocusText` with the updated shadow color.
    public func shadowColor(_ color: Color) -> FocusText {
        var copy = self
        copy.shadowColor = color
        return copy
    }

    /// Sets the shadow radius of the `FocusText`.
    /// - Parameter radius: The radius of the shadow.
    /// - Returns: A new `FocusText` with the updated shadow radius.
    public func shadowRadius(_ radius: CGFloat) -> FocusText {
        var copy = self
        copy.shadowRadius = radius
        return copy
    }

    /// Sets the padding around the content of the `FocusText`.
    /// - Parameter value: The padding value to apply.
    /// - Returns: A new `FocusText` with the updated padding.
    public func padding(_ value: CGFloat) -> FocusText {
        var copy = self
        copy.padding = value
        return copy
    }
}
