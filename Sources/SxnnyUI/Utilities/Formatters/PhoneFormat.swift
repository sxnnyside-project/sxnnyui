//
//  PhoneFormat.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 31/03/25.
//

import Foundation

/// PhoneFormat
///
/// A utility namespace that provides static methods for formatting North American 10‑digit phone numbers
/// into common string representations.
///
/// Supported styles:
/// - With Brackets: "(123) 456 7890"
/// - Without Brackets: "123 456 7890"
/// - With Country Code: "+1 123 456 7890"
/// - With Country Code and Brackets: "+1 (123) 456 7890"
///
/// If the input does not match the expected format (10 digits starting with [2-9] for the area code,
/// or the special "860" prefix followed by 9 digits), the original string is returned unchanged.
public enum PhoneFormat: Sendable {

    // MARK: - Constants

    /// Regex that matches a 10‑digit NANP number or the specific "860" prefix rule.
    @usableFromInline
    static let phoneRegexPattern = "[2-9]\\d{2}\\d{3}\\d{4}|860\\d{9}"

    // MARK: - Validation

    /// Returns true if the phoneNumber matches the expected pattern.
    @inlinable
    public static func isValidNorthAmerican(_ phoneNumber: String) -> Bool {
        phoneNumber.range(of: phoneRegexPattern, options: .regularExpression) != nil
    }

    // MARK: - Formatting

    /// Formats a phone number into a string with brackets (e.g., "(123) 456 7890").
    /// - Parameter phoneNumber: The raw 10‑digit phone number string.
    /// - Returns: The formatted number, or the original string if it does not match the expected pattern.
    @inlinable
    public static func formatPhoneNumberWithBrackets(_ phoneNumber: String) -> String {
        guard isValidNorthAmerican(phoneNumber), phoneNumber.count >= 10 else {
            return phoneNumber
        }

        var index = phoneNumber.startIndex

        let areaStart = index
        let areaEnd = phoneNumber.index(areaStart, offsetBy: 2)
        let area = phoneNumber[areaStart...areaEnd]
        index = phoneNumber.index(after: areaEnd)

        let prefixStart = index
        let prefixEnd = phoneNumber.index(prefixStart, offsetBy: 2)
        let prefix = phoneNumber[prefixStart...prefixEnd]
        index = phoneNumber.index(after: prefixEnd)

        // Remaining characters form the line number (could be more than 4 if caller passed more digits; we keep parity with original behavior)
        let line = phoneNumber[index...]

        return "(\(area)) \(prefix) \(line)"
    }

    /// Formats a phone number into a string without brackets (e.g., "123 456 7890").
    /// - Parameter phoneNumber: The raw 10‑digit phone number string.
    /// - Returns: The formatted number, or the original string if it does not match the expected pattern.
    @inlinable
    public static func formatPhoneNumberWithoutBrackets(_ phoneNumber: String) -> String {
        guard isValidNorthAmerican(phoneNumber), phoneNumber.count >= 10 else {
            return phoneNumber
        }

        var index = phoneNumber.startIndex

        let areaStart = index
        let areaEnd = phoneNumber.index(areaStart, offsetBy: 2)
        let area = phoneNumber[areaStart...areaEnd]
        index = phoneNumber.index(after: areaEnd)

        let prefixStart = index
        let prefixEnd = phoneNumber.index(prefixStart, offsetBy: 2)
        let prefix = phoneNumber[prefixStart...prefixEnd]
        index = phoneNumber.index(after: prefixEnd)

        let line = phoneNumber[index...]

        return "\(area) \(prefix) \(line)"
    }

    /// Formats a phone number into a string with a country code (e.g., "+1 123 456 7890").
    /// - Parameters:
    ///   - phoneNumber: The raw 10‑digit phone number string.
    ///   - countryCode: The country code to prepend.
    /// - Returns: The formatted number, or the original string if it does not match the expected pattern.
    @inlinable
    public static func formatPhoneNumberWithCountryCode(_ phoneNumber: String, countryCode: String) -> String {
        let core = formatPhoneNumberWithoutBrackets(phoneNumber)
        return isValidNorthAmerican(phoneNumber) ? "+\(countryCode) \(core)" : core
    }

    /// Formats a phone number into a string with a country code and brackets (e.g., "+1 (123) 456 7890").
    /// - Parameters:
    ///   - phoneNumber: The raw 10‑digit phone number string.
    ///   - countryCode: The country code to prepend.
    /// - Returns: The formatted number, or the original string if it does not match the expected pattern.
    @inlinable
    public static func formatPhoneNumberWithCountryCodeAndBrackets(_ phoneNumber: String, countryCode: String) -> String {
        let core = formatPhoneNumberWithBrackets(phoneNumber)
        return isValidNorthAmerican(phoneNumber) ? "+\(countryCode) \(core)" : core
    }
}
