//
//  FloatFormatter.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import Foundation

/// FloatFormatter
///
/// A `Formatter` subclass backed by `NumberFormatter` for formatting and parsing floating‑point numbers
/// with consistent settings. Safe to use from multiple threads by serializing access to its internal
/// `NumberFormatter` instance.
///
/// Default behavior:
/// - Decimal style
/// - Maximum 2 fraction digits
/// - Uses the provided or current `Locale`
///
/// Provides:
/// - `string(for:)` for Cocoa formatting pipelines
/// - `getObjectValue(_:for:errorDescription:)` for parsing
/// - Convenience static helpers for direct formatting/parsing without an instance
public final class FloatFormatter: Formatter {

    // MARK: - Private state

    /// NumberFormatter is not thread-safe; guard access with a lock.
    private let numberFormatter: NumberFormatter
    private let lock = NSLock()

    // MARK: - Initialization

    /// Initializes a new instance of `FloatFormatter`.
    ///
    /// - Parameters:
    ///   - maximumFractionDigits: The maximum number of fraction digits to display. Defaults to 2.
    ///   - minimumFractionDigits: The minimum number of fraction digits to display. Defaults to 0.
    ///   - locale: Optional locale; defaults to `Locale.current`.
    public init(
        maximumFractionDigits: Int = 2,
        minimumFractionDigits: Int = 0,
        locale: Locale = .current
    ) {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = maximumFractionDigits
        nf.minimumFractionDigits = minimumFractionDigits
        nf.locale = locale
        self.numberFormatter = nf
        super.init()
    }

    /// Required initializer (unavailable).
    /// Use `init(maximumFractionDigits:minimumFractionDigits:locale:)` instead.
    @available(*, unavailable, message: "Use init(maximumFractionDigits:minimumFractionDigits:locale:) instead.")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is unavailable. Use the designated initializer.")
    }

    // MARK: - Formatting

    /// Returns a formatted string representation of the given object (NSNumber expected).
    /// - Parameter obj: The object to format, expected to be an `NSNumber`.
    /// - Returns: A formatted string if the object is an `NSNumber`, or `nil` otherwise.
    public override func string(for obj: Any?) -> String? {
        guard let number = obj as? NSNumber else { return nil }
        lock.lock()
        defer { lock.unlock() }
        return numberFormatter.string(from: number)
    }

    // MARK: - Parsing

    /// Parses a string into an object value.
    /// - Parameters:
    ///   - obj: A pointer to the object that will hold the parsed value (NSNumber).
    ///   - string: The string to parse.
    ///   - errorDescription: A pointer to an error description if parsing fails.
    /// - Returns: `true` if the string was successfully parsed into a number, or `false` otherwise.
    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        lock.lock()
        let number = numberFormatter.number(from: string)
        lock.unlock()

        if let number {
            obj?.pointee = number
            return true
        } else {
            if let errorDescription {
                errorDescription.pointee = "Invalid number format" as NSString
            }
            return false
        }
    }
}

// MARK: - Convenience API

public extension FloatFormatter {
    /// Formats a floating‑point value using a temporary formatter.
    /// - Parameters:
    ///   - value: The value to format.
    ///   - maximumFractionDigits: The maximum number of fraction digits to display. Defaults to 2.
    ///   - minimumFractionDigits: The minimum number of fraction digits to display. Defaults to 0.
    ///   - locale: Optional locale; defaults to `Locale.current`.
    /// - Returns: A formatted string, or `nil` if formatting fails.
    static func string<T: BinaryFloatingPoint>(
        from value: T,
        maximumFractionDigits: Int = 2,
        minimumFractionDigits: Int = 0,
        locale: Locale = .current
    ) -> String? {
        let formatter = FloatFormatter(
            maximumFractionDigits: maximumFractionDigits,
            minimumFractionDigits: minimumFractionDigits,
            locale: locale
        )
        return formatter.string(for: NSNumber(value: Double(value)))
    }

    /// Attempts to parse a string into a numeric value using a temporary formatter.
    /// - Parameters:
    ///   - string: The input string.
    ///   - maximumFractionDigits: The maximum number of fraction digits accepted. Defaults to 2.
    ///   - minimumFractionDigits: The minimum number of fraction digits accepted. Defaults to 0.
    ///   - locale: Optional locale; defaults to `Locale.current`.
    /// - Returns: A Double if parsing succeeds; otherwise `nil`.
    static func number(
        from string: String,
        maximumFractionDigits: Int = 2,
        minimumFractionDigits: Int = 0,
        locale: Locale = .current
    ) -> Double? {
        let formatter = FloatFormatter(
            maximumFractionDigits: maximumFractionDigits,
            minimumFractionDigits: minimumFractionDigits,
            locale: locale
        )
        var obj: AnyObject?
        let success = formatter.getObjectValue(&obj, for: string, errorDescription: nil)
        if success, let number = obj as? NSNumber {
            return number.doubleValue
        }
        return nil
    }
}
