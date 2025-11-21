//
//  TopLabeledStyleConfig.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//


import SwiftUI

/// A custom labeled content style that arranges the label above the content in a vertical stack.
public struct TopLabeledStyleConfig: LabeledContentStyle {
    
    /// Creates the body of the labeled content style.
    /// - Parameter configuration: The configuration containing the label and content views.
    /// - Returns: A view that arranges the label above the content in a vertical stack, aligned to the leading edge.
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.caption) // Applies a caption font style to the label.
            configuration.content
        }
    }
}

@available(iOS 16.0, *)
extension LabeledContentStyle where Self == TopLabeledStyleConfig {
    /// A static property to easily access the `TopLabeledStyleConfig`.
    public static var topLabeledStyle: TopLabeledStyleConfig { TopLabeledStyleConfig() }
}
