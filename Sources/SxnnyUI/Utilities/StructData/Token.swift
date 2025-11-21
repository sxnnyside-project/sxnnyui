//
//  Token.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import Foundation

/// A data model representing a token, typically used for tagging or segmenting text input.
///
/// `Token` is a value type that supports identification and hashing, making it suitable for use in SwiftUI lists
/// and collections. Each token contains a unique identifier and a text value, allowing it to be rendered,
/// selected, or manipulated individually.
///
/// Conforms to:
/// - `Identifiable`: Enables the use of tokens in list-like UI components.
/// - `Hashable`: Allows tokens to serve as dictionary keys or be stored in sets.
/// - `Codable`: Enables encoding/decoding for persistence or networking.
/// - `Sendable`: Safe to pass across concurrency domains.
///
/// Typical usage involves generating tokens from user input (e.g., in a tag entry field), displaying them,
/// and supporting efficient updates or deletions.
public struct Token: Identifiable, Hashable, Codable, Sendable {
    /// A unique identifier for the token.
    public let id: UUID
    /// The text content of the token.
    public var text: String

    /// Initializes a new instance of `Token`.
    /// - Parameters:
    ///   - id: Optional stable identifier. Defaults to a new `UUID()`.
    ///   - text: The text content of the token.
    public init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}

// MARK: - Convenience

public extension Token {
    /// Returns `true` if the token has no visible characters after trimming whitespace and newlines.
    var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
