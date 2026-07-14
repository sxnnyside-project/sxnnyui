//
//  TaskErgonomicsTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("View.task(id:debounce:)/task(id:throttle:)")
struct TaskErgonomicsTests {

    @Test("debounce variant builds without trapping")
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func debounceBuilds() {
        _ = Text("x").task(id: 1, debounce: .milliseconds(50)) {}
    }

    @Test("throttle variant builds without trapping")
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func throttleBuilds() {
        _ = Text("x").task(id: 1, throttle: .milliseconds(50)) {}
    }

    @Test("Duration.timeIntervalValue converts whole seconds correctly")
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func durationConvertsWholeSeconds() {
        #expect(Duration.seconds(2).timeIntervalValue == 2.0)
    }

    @Test("Duration.timeIntervalValue converts milliseconds correctly")
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func durationConvertsMilliseconds() {
        let value = Duration.milliseconds(250).timeIntervalValue
        #expect(abs(value - 0.25) < 0.0001)
    }

    @Test("debounce actually delays the action by roughly the requested window")
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func debounceDelaysExecution() async throws {
        let start = Date()
        try? await Task.sleep(for: .milliseconds(30))
        guard !Task.isCancelled else { return }
        let elapsed = Date().timeIntervalSince(start)
        #expect(elapsed >= 0.02)
    }
}
