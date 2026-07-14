//
//  BadgeTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("Badge construction, defaults, and the .badge() modifier")
struct BadgeTests {

    @Test("stores the count and image name it was created with")
    func storesConstructorValues() {
        let countBadge = Badge(count: 5)
        #expect(countBadge.count == 5)
        #expect(countBadge.imageName == nil)

        let imageBadge = Badge(imageName: "star.fill")
        #expect(imageBadge.imageName == "star.fill")
        #expect(imageBadge.count == nil)
    }

    @Test("defaults to red color and 15pt diameter")
    func defaults() {
        let badge = Badge(count: 1)
        #expect(badge.color == .red)
        #expect(badge.diameter == 15)
    }

    @Test("accepts custom color and diameter")
    func customAppearance() {
        let badge = Badge(count: 1, color: .blue, diameter: 20)
        #expect(badge.color == .blue)
        #expect(badge.diameter == 20)
    }

    @Test("the .badge() modifier builds without trapping for every parameter combination")
    func modifierBuilds() {
        _ = Text("x").badge(count: 3)
        _ = Text("x").badge(imageName: "bell")
        _ = Text("x").badge(count: 3, color: .green, diameter: 12, alignment: .bottomLeading)
        _ = Text("x").badge()  // neither count nor imageName: no badge shown, must not trap
    }
}
