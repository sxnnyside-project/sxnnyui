//
//  TokenView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines `TokenView`, a SwiftUI view that displays a token with an optional
//  badge for deletion. The implementation follows Swift package and documentation best
//  practices, offering clear API semantics and compatibility handling.
//

import SwiftUI

// MARK: - TokenView

/// A view that displays a token with an optional badge for deletion.
///
/// `TokenView` presents the token's text and overlays a badge that, when tapped,
/// triggers the provided deletion closure. This is useful for tag editors, multi-selection
/// lists, and similar scenarios.
///
/// Example usage:
/// ```swift
/// TokenView(token: myToken) { token in
///     // Handle deletion
/// }
/// ```
public struct TokenView: View {
    /// The token to display.
    public var token: Token
    
    /// A closure invoked when the token is deleted.
    public var onDelete: (Token) -> Void

    /// Creates a new `TokenView`.
    ///
    /// - Parameters:
    ///   - token: The token object whose text is displayed.
    ///   - onDelete: A closure called when the token is tapped for deletion.
    public init(token: Token, onDelete: @escaping (Token) -> Void) {
        self.token = token
        self.onDelete = onDelete
    }

    /// The view’s body, rendering the text with a badge for deletion.
    public var body: some View {
        HStack {
            if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                Text(token.text)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .badge(imageName: "xmark")
                    .onTapGesture {
                        onDelete(token)
                    }
            } else {
                // Fallback for earlier platforms: render without badge
                Text(token.text)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                    .onTapGesture {
                        onDelete(token)
                    }
            }
        }
    }
}
