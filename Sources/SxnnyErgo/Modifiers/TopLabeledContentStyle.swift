//
//  TopLabeledContentStyle.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - TopLabeledContentStyle
//
// `LabeledContent`'s default style places the label beside the content, but
// Settings-style detail rows (and most form-review screens) need the label above the
// value instead. This is a native `LabeledContentStyle` conformance — the same
// extension point Apple uses for its own labeled-content styles.

/// A `LabeledContentStyle` that places the label above the content, both leading-aligned.
///
/// ```swift
/// LabeledContent("Title", value: "Value")
///     .labeledContentStyle(.topLabeledStyle)
/// ```
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct TopLabeledContentStyle: LabeledContentStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.caption)
            configuration.content
        }
    }
}

// MARK: - Static Accessor

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension LabeledContentStyle where Self == TopLabeledContentStyle {
    /// A labeled content style that places the label above the content.
    public static var topLabeledStyle: TopLabeledContentStyle { TopLabeledContentStyle() }
}
