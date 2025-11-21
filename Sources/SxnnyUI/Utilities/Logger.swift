//
//  Logger.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 21/01/25.
//

import Foundation

// MARK: - Internal state and implementation

/// An internal actor that manages throttled logging state safely under Swift concurrency.
private actor _LoggerState {
    static let shared = _LoggerState()

    /// Stores the last log time for each identifier.
    private var lastLogTimes: [String: Date] = [:]

    /// Returns true if the message for the identifier should be logged given the interval, and updates the timestamp.
    func shouldLogAndUpdate(identifier: String, interval: TimeInterval, now: Date = Date()) -> Bool {
        let last = lastLogTimes[identifier] ?? .distantPast
        if now.timeIntervalSince(last) > interval {
            lastLogTimes[identifier] = now
            return true
        }
        return false
    }

    /// Resets the throttling timer for the given identifier.
    func reset(identifier: String) {
        lastLogTimes[identifier] = .distantPast
    }

    /// Clears all throttling timers.
    func clearAll() {
        lastLogTimes.removeAll()
    }
}

// MARK: - Public API

/// Logger
///
/// A simple, thread-safe logger that throttles repeated log messages by identifier and time interval.
/// It prevents flooding the console with repetitive entries by only printing a given identifier
/// once per interval (default: 60 seconds) unless reset.
///
/// Features:
/// - Throttled logging by identifier.
/// - Thread-safe via an internal actor.
/// - Utility methods for resetting or clearing timers.
///
/// Usage:
/// - Logger.log("Message", identifier: "[debug]", interval: 30)
/// - Logger.resetTimer(for: "[debug]")
/// - Logger.clearAllTimers()
public enum Logger {
    /// Default log interval in seconds.
    public static let defaultLogInterval: TimeInterval = 60

    /// Logs a message with a specific identifier and interval. Throttled per identifier.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - identifier: The group identifier for the log (e.g., "[debug]", "[error]").
    ///   - interval: The time interval in seconds to throttle logs for this identifier. Defaults to `defaultLogInterval`.
    @discardableResult
    public static func log(_ message: String, identifier: String, interval: TimeInterval = defaultLogInterval) -> Bool {
        // Use async/await under the hood but keep a synchronous facade for convenience.
        var didLog = false
        let semaphore = DispatchSemaphore(value: 0)

        Task {
            let shouldLog = await _LoggerState.shared.shouldLogAndUpdate(identifier: identifier, interval: interval)
            if shouldLog {
                print("\(identifier) \(message)")
                didLog = true
            }
            semaphore.signal()
        }

        semaphore.wait()
        return didLog
    }

    /// Logs a message with the default interval. Deprecated: Use `log(_:identifier:interval:)` instead.
    ///
    /// - Parameter message: The message to log.
    @available(*, deprecated, message: "Use log(_:identifier:interval:) instead.")
    public static func log(_ message: String) {
        _ = log(message, identifier: "[default]")
    }

    /// Resets the timer for a specific identifier.
    ///
    /// - Parameter identifier: The group identifier whose timer should be reset.
    public static func resetTimer(for identifier: String) {
        Task {
            await _LoggerState.shared.reset(identifier: identifier)
        }
    }

    /// Clears all timers for all identifiers.
    public static func clearAllTimers() {
        Task {
            await _LoggerState.shared.clearAll()
        }
    }
}
