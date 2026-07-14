//
//  IfExtensionsTests.swift
//  SxnnyErgoTests
//

import SwiftUI
import Testing

@testable import SxnnyErgo

/// These tests verify branch-selection logic, not rendered pixel output: SxnnyErgo ships no
/// snapshot/inspection dependency (see PACKAGE_MODEL.md §5, zero third-party dependencies).
/// Each conditional helper evaluates its branch eagerly when building the returned view
/// value, so a side-effecting closure lets us assert exactly one branch ran.
@MainActor
@Suite("View.if / ifElse / ifLet / ifLetElse branch selection")
struct IfExtensionsTests {

    @Test("if(_:transform:) invokes the transform when the condition is true")
    func ifTrueInvokesTransform() {
        var invoked = false
        _ = Text("x").if(true) { view in
            invoked = true
            return view
        }
        #expect(invoked)
    }

    @Test("if(_:transform:) does not invoke the transform when the condition is false")
    func ifFalseSkipsTransform() {
        var invoked = false
        _ = Text("x").if(false) { view in
            invoked = true
            return view
        }
        #expect(!invoked)
    }

    @Test("ifElse invokes exactly the then-branch when true")
    func ifElseTrueInvokesThen() {
        var thenInvoked = false
        var elseInvoked = false
        _ = Text("x").ifElse(true) { view in
            thenInvoked = true
            return view
        } else: { view in
            elseInvoked = true
            return view
        }
        #expect(thenInvoked)
        #expect(!elseInvoked)
    }

    @Test("ifElse invokes exactly the else-branch when false")
    func ifElseFalseInvokesElse() {
        var thenInvoked = false
        var elseInvoked = false
        _ = Text("x").ifElse(false) { view in
            thenInvoked = true
            return view
        } else: { view in
            elseInvoked = true
            return view
        }
        #expect(!thenInvoked)
        #expect(elseInvoked)
    }

    @Test("ifLet invokes the transform with the unwrapped value when non-nil")
    func ifLetSomeInvokesTransform() {
        var received: Int?
        _ = Text("x").ifLet(42) { view, value in
            received = value
            return view
        }
        #expect(received == 42)
    }

    @Test("ifLet does not invoke the transform when the value is nil")
    func ifLetNoneSkipsTransform() {
        var invoked = false
        let value: Int? = nil
        _ = Text("x").ifLet(value) { view, _ in
            invoked = true
            return view
        }
        #expect(!invoked)
    }

    @Test("ifLetElse invokes the then-branch with the unwrapped value when non-nil")
    func ifLetElseSomeInvokesThen() {
        var received: Int?
        var elseInvoked = false
        _ = Text("x").ifLetElse(7) { view, value in
            received = value
            return view
        } else: { view in
            elseInvoked = true
            return view
        }
        #expect(received == 7)
        #expect(!elseInvoked)
    }

    @Test("ifLetElse invokes the else-branch when the value is nil")
    func ifLetElseNoneInvokesElse() {
        var thenInvoked = false
        var elseInvoked = false
        let value: Int? = nil
        _ = Text("x").ifLetElse(value) { view, _ in
            thenInvoked = true
            return view
        } else: { view in
            elseInvoked = true
            return view
        }
        #expect(!thenInvoked)
        #expect(elseInvoked)
    }
}
