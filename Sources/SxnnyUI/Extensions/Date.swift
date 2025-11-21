//
//  Date.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import Foundation

// MARK: - Date Utilities

public extension Date {

    // MARK: Cached Formatter

    /// A cached formatter for the default format to improve performance.
    ///
    /// Uses the format `"yyyy-MM-dd HH:mm:ss"` with the `en_US_POSIX` locale, which is a stable,
    /// non-user-facing locale appropriate for fixed-format parsing and formatting.
    private static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // MARK: Formatting

    /// Returns the date formatted as a string using the provided format string.
    ///
    /// - Important: This uses the `en_US_POSIX` locale to ensure a predictable, fixed-format output,
    ///   which is recommended for non-localized formatting. If you require localized output, use
    ///   `DateFormatter` with appropriate `dateStyle`/`timeStyle` and `locale`.
    ///
    /// - Parameter format: A custom date format string. Defaults to `"yyyy-MM-dd HH:mm:ss"`.
    /// - Returns: A formatted date string.
    @inlinable
    func formatted(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    /// Returns the date formatted using the default cached formatter (`"yyyy-MM-dd HH:mm:ss"`).
    ///
    /// Uses the `en_US_POSIX` locale for a predictable, fixed-format output.
    @inlinable
    func formattedWithDefault() -> String {
        Self.defaultFormatter.string(from: self)
    }

    // MARK: Calendar Checks

    /// A Boolean value indicating whether the date is today, using the current calendar.
    @inlinable
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// A Boolean value indicating whether the date is yesterday, using the current calendar.
    @inlinable
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// A Boolean value indicating whether the date is tomorrow, using the current calendar.
    @inlinable
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    /// A Boolean value indicating whether the date is in the past compared to the current moment.
    @inlinable
    var isInPast: Bool {
        self < Date()
    }

    /// A Boolean value indicating whether the date is in the future compared to the current moment.
    @inlinable
    var isInFuture: Bool {
        self > Date()
    }

    // MARK: Day Boundaries

    /// The start of the day (00:00:00) for this date, using the current calendar and time zone.
    @inlinable
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// The end of the day (23:59:59) for this date, using the current calendar and time zone.
    ///
    /// - Note: This computes one second before the start of the following day. If the calculation fails,
    ///   it returns `self`.
    @inlinable
    var endOfDay: Date {
        guard let end = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) else {
            return self
        }
        return end
    }

    // MARK: Differences

    /// Returns the number of full days between another date and this date.
    ///
    /// Positive values indicate that this date occurs after `date`; negative values indicate it occurs before.
    ///
    /// - Parameter date: The date to compare to.
    /// - Returns: The number of full days between the two dates, or `0` if it cannot be computed.
    @inlinable
    func days(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
