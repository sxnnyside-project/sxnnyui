//
//  DateFormat.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import Foundation

/// DateFormat
///
/// A utility namespace for formatting `Date` values into various string representations.
/// All functions are pure and side‑effect free, creating or using appropriately configured
/// `DateFormatter` instances. For performance, dedicated helpers build formatters on demand.
///
/// Notes:
/// - `DateFormatter` is not thread‑safe; we avoid shared mutable instances across threads.
/// - If you need high‑frequency formatting, consider caching formatters at the call site.
public enum DateFormat: Sendable {

    // MARK: - Private helpers

    @usableFromInline
    static func makeFormatter(
        dateFormat: String,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> DateFormatter {
        let f = DateFormatter()
        f.dateFormat = dateFormat
        if let locale { f.locale = locale }
        if let timeZone { f.timeZone = timeZone }
        return f
    }

    @usableFromInline
    static func makeFormatter(
        dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style = .none,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> DateFormatter {
        let f = DateFormatter()
        f.dateStyle = dateStyle
        f.timeStyle = timeStyle
        if let locale { f.locale = locale }
        if let timeZone { f.timeZone = timeZone }
        return f
    }

    // MARK: - Flat formats

    /// Formats a date into a flat string (e.g., "ddMMyyyyHHmmss").
    /// - Parameters:
    ///   - date: The date to format.
    ///   - locale: Optional locale (defaults to current).
    ///   - timeZone: Optional time zone (defaults to current).
    /// - Returns: A string in "ddMMyyyyHHmmss" format.
    @inlinable
    public static func formatDateFlat(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "ddMMyyyyHHmmss", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    // MARK: - Slash and dash formats

    /// Formats a date into "dd/MM/yyyy".
    @inlinable
    public static func formatDateWithSlash(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "dd/MM/yyyy", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into "dd-MM-yyyy".
    @inlinable
    public static func formatDateWithDash(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "dd-MM-yyyy", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into "dd-MM-yyyy HH:mm:ss".
    @inlinable
    public static func formatDateWithDashAndHour(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "dd-MM-yyyy HH:mm:ss", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into "dd/MM/yyyy HH:mm:ss".
    @inlinable
    public static func formatDateWithSlashAndHour(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "dd/MM/yyyy HH:mm:ss", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    // MARK: - Components

    /// Formats a date into "HH:mm:ss".
    @inlinable
    public static func formatHour(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "HH:mm:ss", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into "yyyy".
    @inlinable
    public static func formatDateYear(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "yyyy", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into "dd".
    @inlinable
    public static func formatDateDay(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "dd", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into "MM".
    @inlinable
    public static func formatDateMonthNumber(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "MM", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into the short month name (e.g., "Jan").
    @inlinable
    public static func formatDateMonthShort(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "MMM", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    // MARK: - Localized month names

    /// Formats a date into the full month name (e.g., "January") using the specified locale and time zone.
    /// - Parameters:
    ///   - date: The date to format.
    ///   - locale: Optional locale to use (defaults to current).
    ///   - timeZone: Optional time zone (defaults to current).
    /// - Returns: The localized month name in full.
    @inlinable
    public static func formatDateMonthLarge(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        let formatter = makeFormatter(dateFormat: "LLLL", locale: locale, timeZone: timeZone)
        return formatter.string(from: date)
    }

    /// Formats a date into "LLLL HH:mm" (e.g., "January 13:45") with localized month name and short time.
    /// - Parameters:
    ///   - date: The date to format.
    ///   - locale: Optional locale to use (defaults to current).
    ///   - timeZone: Optional time zone (defaults to current).
    /// - Returns: The localized full month name plus short time.
    @inlinable
    public static func formatDateMonthHourLarge(
        date: Date,
        locale: Locale? = nil,
        timeZone: TimeZone? = nil
    ) -> String {
        // Use two formatters to honor locale-specific time formats while keeping month name localized.
        let monthFormatter = makeFormatter(dateFormat: "LLLL", locale: locale, timeZone: timeZone)
        let timeFormatter = makeFormatter(dateStyle: .none, timeStyle: .short, locale: locale, timeZone: timeZone)
        let month = monthFormatter.string(from: date)
        let time = timeFormatter.string(from: date)
        return "\(month) \(time)"
    }
}
