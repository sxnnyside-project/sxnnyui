//
//  TopLabeledStyleConfig.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  Provides a labeled content style that places the label above the content in a vertical stack.
//  Written and documented with Swift package best practices.
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - TopLabeledStyleConfig

/// A labeled content style that arranges the label above the content in a vertical stack.
///
/// Use `TopLabeledStyleConfig` to present a label above its value, both leading-aligned.
/// This style applies a `.caption` font to the label for visual distinction.
///
/// Example usage:
/// ```swift
/// if #available(iOS 16, macOS 13, *) {
///     LabeledContent("Title", value: "Value")
///         .labeledContentStyle(.topLabeledStyle)
/// }
/// ```
///
/// - Note: Available on iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0 and later.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct TopLabeledStyleConfig: LabeledContentStyle {
    /// Creates the labeled content view with the label above the content.
    ///
    /// - Parameter configuration: The input containing the label and content.
    /// - Returns: A vertical stack with the label above the content, leading aligned.
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.caption)
            configuration.content
        }
    }
}

// MARK: - Convenience Static Property

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public extension LabeledContentStyle where Self == TopLabeledStyleConfig {
    /// A labeled content style where the label is displayed above the content.
    ///
    /// Use this property to apply the style:
    /// ```swift
    /// .labeledContentStyle(.topLabeledStyle)
    /// ```
    static var topLabeledStyle: TopLabeledStyleConfig { TopLabeledStyleConfig() }
}

#endif
