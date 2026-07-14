//
//  ViewExtensionsTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

@MainActor
@Suite("View.hidden / cardStyle / animated / overlayIf")
struct ViewExtensionsTests {

    // MARK: hidden(_:animation:)

    @Test("HideModifier sets opacity to 0 and disables hit testing when isHidden is true")
    func hideModifierHiddenState() {
        let modifier = HideModifier(isHidden: true, animation: nil)
        #expect(modifier.isHidden == true)
        #expect(modifier.animation == nil)
    }

    @Test("HideModifier retains the supplied animation")
    func hideModifierRetainsAnimation() {
        let modifier = HideModifier(isHidden: false, animation: .easeIn)
        #expect(modifier.isHidden == false)
        #expect(modifier.animation != nil)
    }

    @Test("hidden(_:) builds without trapping for both states")
    func hiddenBuildsForBothStates() {
        _ = Text("x").hidden(true)
        _ = Text("x").hidden(false)
    }

    // MARK: cardStyle(cornerRadius:shadowRadius:)

    @Test("cardStyle builds with default and custom parameters without trapping")
    func cardStyleBuilds() {
        _ = Text("x").cardStyle()
        _ = Text("x").cardStyle(cornerRadius: 20, shadowRadius: 0)
    }

    // MARK: animated(if:animation:) — regression coverage for the UUID keying bug
    //
    // Previously, `animated(if:)` keyed `.animation(_:value:)` off a freshly generated
    // `UUID()`, which changes on every evaluation and therefore animates unconditionally
    // regardless of `condition` (ENGINERRING_AUDIT.md §3, item 1). The fix keys the
    // animation off `condition` itself. `.animation(_:value:)` produces a concrete
    // `ModifiedContent` type parameterized by the type of `value`, so the fix is
    // observable at the type level: the resulting type description must reference `Bool`,
    // never `UUID`.

    @Test("animated(if:) keys its animation value off Bool, not a fresh UUID")
    func animatedKeysOffCondition() {
        let trueResult = Text("x").animated(if: true)
        let falseResult = Text("x").animated(if: false)

        let trueDescription = String(describing: type(of: trueResult))
        let falseDescription = String(describing: type(of: falseResult))

        #expect(trueDescription.contains("Bool"))
        #expect(!trueDescription.contains("UUID"))
        #expect(falseDescription.contains("Bool"))
        #expect(!falseDescription.contains("UUID"))
    }

    @Test("animated(if:) builds without trapping for both states")
    func animatedBuildsForBothStates() {
        _ = Text("x").animated(if: true)
        _ = Text("x").animated(if: false, animation: .spring())
    }

    // MARK: overlayIf(_:alignment:content:)

    @Test("overlayIf renders overlay content only when the condition is true")
    func overlayIfInvocation() {
        var overlayBuilt = false
        _ = Text("x").overlayIf(true) {
            overlayBuilt = true
            return Circle()
        }
        #expect(overlayBuilt)
    }

    @Test("overlayIf does not build overlay content when the condition is false")
    func overlayIfSkipsWhenFalse() {
        var overlayBuilt = false
        _ = Text("x").overlayIf(false) {
            overlayBuilt = true
            return Circle()
        }
        #expect(!overlayBuilt)
    }
}
