//
//  TimeFormat.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 31/03/25.
//

import Foundation

/// TimeFormat
///
/// A utility namespace for converting time intervals into user‑friendly string representations.
///
/// Provides formatting helpers for:
/// - "mm:ss"
/// - "hh:mm:ss"
/// - "mm:ss.SSS" (milliseconds input)
/// - "mm:ss.SSSnnnnnnnnn" (nanoseconds input)
///
/// Overloads accept `TimeInterval`, `BinaryInteger`, and `BinaryFloatingPoint` as appropriate.
public enum TimeFormat: Sendable {

    // MARK: - Constants

    @usableFromInline static let secondsPerMinute = 60
    @usableFromInline static let secondsPerHour = 3600
    @usableFromInline static let millisecondsPerSecond = 1_000
    @usableFromInline static let millisecondsPerMinute = 60_000
    @usableFromInline static let nanosecondsPerMillisecond = 1_000_000
    @usableFromInline static let nanosecondsPerSecond = 1_000_000_000
    @usableFromInline static let nanosecondsPerMinute = 60 * 1_000_000_000

    // MARK: - mm:ss

    /// Formats a time interval into "mm:ss".
    /// - Parameter timeInterval: The time interval to format, in seconds.
    /// - Returns: A string in "mm:ss".
    @inlinable
    public static func formatTime(_ timeInterval: TimeInterval) -> String {
        formatTime(Int(timeInterval))
    }

    /// Formats a time interval into "mm:ss" for integer seconds.
    @inlinable
    public static func formatTime<T: BinaryInteger>(_ seconds: T) -> String {
        let total = Int(seconds)
        let minutes = total / secondsPerMinute
        let secs = total % secondsPerMinute
        return String(format: "%02d:%02d", minutes, secs)
    }

    /// Formats a time interval into "mm:ss" for floating‑point seconds.
    @inlinable
    public static func formatTime<T: BinaryFloatingPoint>(_ seconds: T) -> String {
        formatTime(Int(seconds))
    }

    // MARK: - hh:mm:ss

    /// Formats a time interval into "hh:mm:ss" for integer seconds.
    @inlinable
    public static func formatHourMinuteSecond<T: BinaryInteger>(_ seconds: T) -> String {
        let total = Int(seconds)
        let hours = total / secondsPerHour
        let minutes = (total % secondsPerHour) / secondsPerMinute
        let secs = total % secondsPerMinute
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }

    /// Formats a time interval into "hh:mm:ss" for floating‑point seconds.
    @inlinable
    public static func formatHourMinuteSecond<T: BinaryFloatingPoint>(_ seconds: T) -> String {
        formatHourMinuteSecond(Int(seconds))
    }

    // MARK: - mm:ss.SSS (milliseconds input)

    /// Formats a duration into "mm:ss.SSS" for integer milliseconds.
    /// - Parameter milliseconds: Duration in milliseconds.
    @inlinable
    public static func formatTimeMillisecond<T: BinaryInteger>(_ milliseconds: T) -> String {
        let totalMS = Int(milliseconds)
        let minutes = totalMS / millisecondsPerMinute
        let seconds = (totalMS % millisecondsPerMinute) / millisecondsPerSecond
        let ms = totalMS % millisecondsPerSecond
        return String(format: "%02d:%02d.%03d", minutes, seconds, ms)
    }

    /// Formats a duration into "mm:ss.SSS" for floating‑point milliseconds.
    @inlinable
    public static func formatTimeMillisecond<T: BinaryFloatingPoint>(_ milliseconds: T) -> String {
        formatTimeMillisecond(Int(milliseconds))
    }

    // MARK: - mm:ss.SSSnnnnnnnnn (nanoseconds input)

    /// Formats a duration into "mm:ss.SSSnnnnnnnnn" for integer nanoseconds.
    /// - Parameter nanoseconds: Duration in nanoseconds.
    ///
    /// The fractional portion is split into milliseconds (SSS) and the remaining 9‑digit nanoseconds (nnnnnnnnn).
    @inlinable
    public static func formatTimeNanosecond<T: BinaryInteger>(_ nanoseconds: T) -> String {
        let totalNS = Int(nanoseconds)

        let minutes = totalNS / nanosecondsPerMinute
        let seconds = (totalNS % nanosecondsPerMinute) / nanosecondsPerSecond

        // Remaining nanoseconds within the current second
        let nsWithinSecond = totalNS % nanosecondsPerSecond

        // Milliseconds are the upper 3 digits of the 9‑digit fractional part.
        let milliseconds = nsWithinSecond / nanosecondsPerMillisecond

        // Remaining nanoseconds after removing milliseconds (0...999_999)
        let remainingNS = nsWithinSecond % nanosecondsPerMillisecond

        // Compose "SSSnnnnnnnnn" where SSS are milliseconds and nnnnnnnnn are the remaining 9 digits.
        // We need 9 digits after the decimal: 3 for ms, 6 for remainingNS padded to 6 digits.
        // But the classic format "SSSnnnnnnnnn" expects 3 + 9 = 12 total digits; typically we show 3 + 6? 
        // Here we will format as 3(ms) + 6(ns) = 9 total fractional digits to match "SSSnnnnnnn".
        // If you require exactly 9 digits after SSS (total 12), adjust accordingly.
        return String(format: "%02d:%02d.%03d%06d", minutes, seconds, milliseconds, remainingNS)
    }

    /// Formats a duration into "mm:ss.SSSnnnnnnnnn" for floating‑point nanoseconds.
    @inlinable
    public static func formatTimeNanosecond<T: BinaryFloatingPoint>(_ nanoseconds: T) -> String {
        formatTimeNanosecond(Int(nanoseconds))
    }
}
