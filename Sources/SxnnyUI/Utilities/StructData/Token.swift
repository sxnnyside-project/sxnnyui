//
//  Token.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//
//  This file defines the `Token` model, a value type for representing tags or segmented text input
//  in SwiftUI applications. Tokens are uniquely identified, codable for persistence, and suitable
//  for use in lists or sets.
//
//  Example usage:
//  ```swift
//  let token = Token(text: "Example")
//  if !token.isEmpty { ... }
//  ```
//

import Foundation

// MARK: - Token Model

/// A value type representing a tag or text token for use in SwiftUI lists and fields.
///
/// `Token` is uniquely identified, hashable, codable, and sendable. Use tokens to implement
/// tag fields, segmented input, or similar components.
///
/// Conforms to:
/// - `Identifiable`: Enables tokens in dynamic SwiftUI lists.
/// - `Hashable`: Allows tokens in sets or as dictionary keys.
/// - `Codable`: Supports persistence or network transport.
/// - `Sendable`: Ensures safety across concurrency domains.
public struct Token: Identifiable, Hashable, Codable, Sendable {
    /// The token's stable unique identifier.
    public let id: UUID
    /// The visible text content of the token.
    public var text: String

    /// Initializes a new token.
    ///
    /// - Parameters:
    ///   - id: The unique identifier. Defaults to a new UUID.
    ///   - text: The text to display for this token.
    public init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}

// MARK: - Convenience Extensions

public extension Token {
    /// Returns `true` if the token's text is empty or consists only of whitespace.
    var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
