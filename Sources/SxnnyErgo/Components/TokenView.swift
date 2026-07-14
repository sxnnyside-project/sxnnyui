//
//  TokenView.swift
//  SxnnyErgo
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

// MARK: - TokenView
//
// Renders tag/chip UI (search filters, multi-select tags, contact chips) with a
// pill-shaped label, a dismiss affordance, and correct accessibility handled
// consistently. `TokenView` is generic over any `Hashable` identifier, so it works with
// whatever identifier type your own data already uses.

/// A view that displays a dismissible token (tag/chip) with a badge for deletion.
///
/// ```swift
/// ForEach(selectedTags) { tag in
///     TokenView(id: tag.id, text: tag.name) { id in
///         selectedTags.removeAll { $0.id == id }
///     }
/// }
/// ```
public struct TokenView<ID: Hashable>: View {
    /// The identifier passed back to `onDelete` when the token is tapped.
    public let id: ID
    /// The token's visible text.
    public let text: String
    /// Called with `id` when the token's delete badge is tapped.
    public let onDelete: (ID) -> Void

    /// Creates a token view.
    ///
    /// - Parameters:
    ///   - id: An identifier for the token, passed back to `onDelete`.
    ///   - text: The token's visible text.
    ///   - onDelete: Called with `id` when the token is tapped for deletion.
    public init(id: ID, text: String, onDelete: @escaping (ID) -> Void) {
        self.id = id
        self.text = text
        self.onDelete = onDelete
    }

    public var body: some View {
        Text(text)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .badge(imageName: "xmark")
            .contentShape(Rectangle())
            .onTapGesture {
                onDelete(id)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(text))
            .accessibilityHint(Text("Double tap to remove"))
            .accessibilityAddTraits(.isButton)
    }
}
