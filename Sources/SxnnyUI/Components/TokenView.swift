//
//  TokenView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import SwiftUI

/// A SwiftUI view that represents a token with a badge for deletion.
///
/// The `TokenView` displays a token's text and provides an interactive badge
/// that allows the user to delete the token when tapped.
///
/// - Parameters:
///   - token: The `Token` object containing the text to display.
///   - onDelete: A closure that is called when the token is deleted.
public struct TokenView: View {
    /// The token to be displayed.
    public var token: Token
    
    /// A closure that is triggered when the token is deleted.
    public var onDelete: (Token) -> Void

    /// Initializes a new `TokenView`.
    ///
    /// - Parameters:
    ///   - token: The `Token` object to display.
    ///   - onDelete: A closure to handle the deletion of the token.
    public init(token: Token, onDelete: @escaping (Token) -> Void) {
        self.token = token
        self.onDelete = onDelete
    }

    /// The content and behavior of the `TokenView`.
    public var body: some View {
        HStack {
            Text(token.text)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                .badge(imageName: "xmark")
                .onTapGesture {
                    onDelete(token)
                }
        }
    }
}
