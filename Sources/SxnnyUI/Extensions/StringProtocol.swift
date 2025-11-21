//
//  StringProtocol.swift
//  SxnnyUI
//
//  Created by Sxnnyide Project on 31/01/25.
//

import Foundation

// MARK: - StringProtocol Utilities

public extension StringProtocol {

    // MARK: Casing

    /// Returns a copy of the string with the first character uppercased.
    ///
    /// The remaining characters are left unchanged.
    @inlinable
    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }

    /// Returns a copy of the string with the first character capitalized (locale-aware).
    ///
    /// The remaining characters are left unchanged.
    @inlinable
    var firstCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }

    /// Returns a copy of the string with the first character lowercased.
    ///
    /// The remaining characters are left unchanged.
    @inlinable
    var firstLowercased: String {
        prefix(1).lowercased() + dropFirst()
    }

    // MARK: Validation

    /// A Boolean value indicating whether the string matches a basic email address pattern.
    ///
    /// - Note: This uses a pragmatic regular expression and is not a complete RFC 5322 validator.
    ///   It should be sufficient for most UI-level checks but may not accept all valid emails.
    @inlinable
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: String(self))
    }

    // MARK: Case Styles

    /// Returns a camelCase version of the string.
    ///
    /// Non-alphanumeric separators are removed. The first component is lowercased; subsequent components are capitalized.
    ///
    /// Example:
    /// - "hello world_test" -> "helloWorldTest"
    @inlinable
    var camelCased: String {
        let parts = String(self)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        guard let first = parts.first?.lowercased() else { return "" }
        let rest = parts.dropFirst().map { $0.capitalized }.joined()
        return first + rest
    }

    /// Returns a snake_case version of the string.
    ///
    /// Inserts underscores between lowercase-to-uppercase boundaries and normalizes spaces and hyphens to underscores.
    ///
    /// Example:
    /// - "helloWorld Test-Value" -> "hello_world_test_value"
    @inlinable
    var snakeCased: String {
        let base = String(self)
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(base.startIndex..., in: base)
        let withUnderscores = regex?.stringByReplacingMatches(
            in: base,
            options: [],
            range: range,
            withTemplate: "$1_$2"
        ) ?? base

        return withUnderscores
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .lowercased()
    }

    /// Returns a kebab-case version of the string.
    ///
    /// Example:
    /// - "helloWorld_test value" -> "hello-world-test-value"
    @inlinable
    var kebabCased: String {
        snakeCased.replacingOccurrences(of: "_", with: "-")
    }

    // MARK: Character Filtering and Trimming

    /// Returns a string containing only the numeric characters in the receiver.
    @inlinable
    var onlyNumbers: String {
        String(filter { $0.isNumber })
    }

    /// Returns the string trimmed of leading and trailing whitespace and newlines.
    @inlinable
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// A Boolean value indicating whether the string is empty or contains only whitespace and newlines.
    @inlinable
    var isBlank: Bool {
        trimmed.isEmpty
    }

    /// The number of characters in the string.
    ///
    /// - Note: This is equivalent to `count` and is provided for readability.
    @inlinable
    var length: Int {
        count
    }

    // MARK: Transformations

    /// Returns a new string formed by repeating the receiver the specified number of times.
    ///
    /// - Parameter times: The number of repetitions. Values less than or equal to zero return an empty string.
    /// - Returns: A concatenated string with `times` repetitions.
    @inlinable
    func repeated(_ times: Int) -> String {
        guard times > 0 else { return "" }
        return String(repeating: String(self), count: times)
    }

    /// Returns a reversed copy of the string.
    @inlinable
    var reversedString: String {
        String(reversed())
    }

    // MARK: Numeric and Palindrome Checks

    /// A Boolean value indicating whether the string can be parsed as a number using `Double`.
    ///
    /// - Note: This relies on `Double` parsing and is not locale-aware (e.g., commas as decimal separators may not be recognized).
    @inlinable
    var isNumeric: Bool {
        Double(String(self)) != nil
    }

    /// A Boolean value indicating whether the string reads the same forwards and backwards.
    ///
    /// - Important: This comparison is case-sensitive and does not ignore whitespace or punctuation.
    @inlinable
    var palindrome: Bool {
        String(self) == reversedString
    }
}
