//
//  TaskErgonomics.swift
//  SxnnyErgo
//

import SwiftUI

// MARK: - Debounced & Throttled Task Attachment

extension View {

    // MARK: Debounce

    /// Attaches an asynchronous task tied to the value of `id`, delaying `action` until
    /// `debounce` has elapsed without `id` changing again.
    ///
    /// Built on `.task(id:)`, which automatically cancels and restarts its underlying `Task`
    /// whenever `id` changes. Each restart re-enters the sleep, so a rapid run of `id` changes
    /// collapses into a single `action` call fired `debounce` after the last change — exactly
    /// like debouncing a search field's text as the user types.
    ///
    /// ```swift
    /// TextField("Search", text: $query)
    ///     .task(id: query, debounce: .milliseconds(300)) {
    ///         await viewModel.search(for: query)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - id: The value that determines the task's identity. Changing it cancels any pending run.
    ///   - debounce: The quiet period `id` must hold steady for before `action` runs.
    ///   - action: The asynchronous work to perform after the debounce window elapses.
    /// - Returns: A view that runs `action` at most once per settled value of `id`.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable
    public func task<ID: Equatable>(
        id: ID,
        debounce: Duration,
        _ action: @escaping @Sendable () async -> Void
    ) -> some View {
        self.task(id: id) {
            try? await Task.sleep(for: debounce)
            guard !Task.isCancelled else { return }
            await action()
        }
    }

    // MARK: Throttle

    /// Attaches an asynchronous task tied to the value of `id`, limiting `action` to at most
    /// one run per `throttle` window.
    ///
    /// Semantics are leading-edge with a coalesced trailing run:
    /// - The first `id` change (or the first change after a quiet period) runs `action` immediately.
    /// - Any further `id` changes that arrive within `throttle` of the last run are coalesced —
    ///   only the most recent one fires, and it fires at the end of the window rather than
    ///   invoking `action` repeatedly.
    ///
    /// A `@State`-held timestamp on the underlying modifier tracks when `action` last ran; this
    /// keeps the implementation simple and easy to reason about rather than introducing an
    /// actor for what is inherently main-actor-scoped view state.
    ///
    /// ```swift
    /// ScrollPositionReader(position: $offset)
    ///     .task(id: offset, throttle: .seconds(1)) {
    ///         await analytics.recordScroll(offset)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - id: The value that determines the task's identity. Changing it re-evaluates throttling.
    ///   - throttle: The minimum interval between two runs of `action`.
    ///   - action: The asynchronous work to perform.
    /// - Returns: A view that runs `action` at most once per `throttle` window.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @inlinable
    public func task<ID: Equatable>(
        id: ID,
        throttle: Duration,
        _ action: @escaping @Sendable () async -> Void
    ) -> some View {
        modifier(ThrottledTaskModifier(id: id, throttle: throttle, action: action))
    }
}

// MARK: - Modifier (usable from inlinable)

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@usableFromInline
struct ThrottledTaskModifier<ID: Equatable>: ViewModifier {
    @usableFromInline let id: ID
    @usableFromInline let throttle: Duration
    @usableFromInline let action: @Sendable () async -> Void
    @State @usableFromInline var lastRunDate: Date?

    @usableFromInline
    init(id: ID, throttle: Duration, action: @escaping @Sendable () async -> Void) {
        self.id = id
        self.throttle = throttle
        self.action = action
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content.task(id: id) {
            let now = Date()
            let interval = throttle.timeIntervalValue

            if let lastRunDate, now.timeIntervalSince(lastRunDate) < interval {
                let remaining = interval - now.timeIntervalSince(lastRunDate)
                try? await Task.sleep(for: .seconds(max(remaining, 0)))
                guard !Task.isCancelled else { return }
                self.lastRunDate = Date()
                await action()
            } else {
                self.lastRunDate = now
                await action()
            }
        }
    }
}

// MARK: - Duration Conversion (usable from inlinable)

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Duration {
    /// The duration expressed as a `TimeInterval` (seconds), used for wall-clock comparisons.
    @usableFromInline
    var timeIntervalValue: TimeInterval {
        let components = self.components
        return Double(components.seconds) + Double(components.attoseconds) / 1e18
    }
}
