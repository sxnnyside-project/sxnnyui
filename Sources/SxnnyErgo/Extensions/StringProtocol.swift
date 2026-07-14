//
//  StringProtocol.swift
//  SxnnyErgo
//
//  Created by Sxnnyide Project on 31/01/25.
//

import Foundation

// MARK: - StringProtocol Utilities

extension StringProtocol {

    // MARK: Casing

    /// Returns a copy of the string with the first character uppercased.
    ///
    /// The remaining characters are left unchanged.
    ///
    /// ```swift
    /// Text(section.title.firstUppercased)
    /// ```
    @inlinable
    public var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }

    /// Returns a copy of the string with the first character capitalized (locale-aware).
    ///
    /// The remaining characters are left unchanged.
    @inlinable
    public var firstCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }

    /// Returns a copy of the string with the first character lowercased.
    ///
    /// The remaining characters are left unchanged.
    @inlinable
    public var firstLowercased: String {
        prefix(1).lowercased() + dropFirst()
    }

    // MARK: Validation

    /// A Boolean value indicating whether the string matches a basic email address pattern.
    ///
    /// Intended for real-time UI validation (enabling a submit button, showing an inline
    /// error) — not for verifying deliverability. Uses a pragmatic pattern and is not a
    /// complete RFC 5322 validator.
    ///
    /// ```swift
    /// TextField("Email", text: $email)
    /// Button("Continue") { submit() }
    ///     .disabled(!email.isValidEmail)
    /// ```
    @inlinable
    public var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: String(self))
    }

    // MARK: Case Styles

    /// Returns a camelCase version of the string.
    ///
    /// Non-alphanumeric separators are removed. The first component is lowercased;
    /// subsequent components are capitalized.
    ///
    /// ```swift
    /// "hello world_test".camelCased // "helloWorldTest"
    /// ```
    @inlinable
    public var camelCased: String {
        let parts = String(self)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
        guard let first = parts.first?.lowercased() else { return "" }
        let rest = parts.dropFirst().map { $0.capitalized }.joined()
        return first + rest
    }

    /// Returns a snake_case version of the string.
    ///
    /// Inserts underscores between lowercase-to-uppercase boundaries and normalizes spaces
    /// and hyphens to underscores.
    ///
    /// ```swift
    /// "helloWorld Test-Value".snakeCased // "hello_world_test_value"
    /// ```
    @inlinable
    public var snakeCased: String {
        let base = String(self)
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(base.startIndex..., in: base)
        let withUnderscores =
            regex?.stringByReplacingMatches(
                in: base,
                options: [],
                range: range,
                withTemplate: "$1_$2"
            ) ?? base

        return
            withUnderscores
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .lowercased()
    }

    /// Returns a kebab-case version of the string.
    ///
    /// ```swift
    /// "helloWorld_test value".kebabCased // "hello-world-test-value"
    /// ```
    @inlinable
    public var kebabCased: String {
        snakeCased.replacingOccurrences(of: "_", with: "-")
    }

    // MARK: Character Filtering and Trimming

    /// Returns a string containing only the numeric characters in the receiver.
    ///
    /// ```swift
    /// "+1 (555) 123-4567".onlyNumbers // "15551234567"
    /// ```
    @inlinable
    public var onlyNumbers: String {
        String(filter { $0.isNumber })
    }

    /// Returns the string trimmed of leading and trailing whitespace and newlines.
    @inlinable
    public var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// A Boolean value indicating whether the string is empty or contains only whitespace
    /// and newlines.
    ///
    /// ```swift
    /// Button("Submit") { submit() }
    ///     .disabled(comment.isBlank)
    /// ```
    @inlinable
    public var isBlank: Bool {
        trimmed.isEmpty
    }
}
