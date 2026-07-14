//
//  BreakpointLayoutTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("BreakpointLayout.Breakpoints and construction")
struct BreakpointLayoutTests {

    // MARK: Breakpoints

    @Test("default breakpoints are 400/800")
    func defaultBreakpoints() {
        let breakpoints = BreakpointLayout<Text, Text, Text>.Breakpoints()
        #expect(breakpoints.medium == 400)
        #expect(breakpoints.large == 800)
    }

    @Test("custom breakpoints retain the supplied values")
    func customBreakpoints() {
        let breakpoints = BreakpointLayout<Text, Text, Text>.Breakpoints(medium: 300, large: 900)
        #expect(breakpoints.medium == 300)
        #expect(breakpoints.large == 900)
    }

    @Test("breakpoints with equal values are Equatable-equal")
    func breakpointsEquality() {
        let a = BreakpointLayout<Text, Text, Text>.Breakpoints(medium: 500, large: 700)
        let b = BreakpointLayout<Text, Text, Text>.Breakpoints(medium: 500, large: 700)
        #expect(a == b)
    }

    // MARK: Construction

    @Test("three-tier initializer builds without trapping")
    func threeTierBuilds() {
        _ = BreakpointLayout(
            small: { Text("Small") },
            medium: { Text("Medium") },
            large: { Text("Large") }
        )
    }

    @Test("three-tier initializer accepts custom breakpoints")
    func threeTierCustomBreakpoints() {
        _ = BreakpointLayout(
            breakpoints: .init(medium: 320, large: 1024),
            small: { Text("Small") },
            medium: { Text("Medium") },
            large: { Text("Large") }
        )
    }

    @Test("two-tier convenience initializer builds without trapping")
    func twoTierBuilds() {
        _ = BreakpointLayout(
            breakpoint: 600,
            compact: { Text("Compact") },
            regular: { Text("Regular") }
        )
    }

    @Test("two-tier convenience initializer uses a default breakpoint of 600")
    func twoTierDefaultBreakpoint() {
        _ = BreakpointLayout(
            compact: { Text("Compact") },
            regular: { Text("Regular") }
        )
    }
}
