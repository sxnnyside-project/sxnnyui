//
//  StringProtocolExtensionsTests.swift
//  SxnnyErgoTests
//

import Testing

@testable import SxnnyErgo

@Suite("StringProtocol casing, validation, case-styles, filtering")
struct StringProtocolExtensionsTests {

    // MARK: Casing

    @Test("firstUppercased capitalizes only the first character")
    func firstUppercasedBasic() {
        #expect("hello".firstUppercased == "Hello")
    }

    @Test("firstUppercased on an already-uppercase string is unchanged")
    func firstUppercasedIdempotent() {
        #expect("Hello".firstUppercased == "Hello")
    }

    @Test("firstUppercased on an empty string returns an empty string")
    func firstUppercasedEmpty() {
        #expect("".firstUppercased == "")
    }

    @Test("firstCapitalized capitalizes only the first character")
    func firstCapitalizedBasic() {
        #expect("hello world".firstCapitalized == "Hello world")
    }

    @Test("firstLowercased lowercases only the first character")
    func firstLowercasedBasic() {
        #expect("HELLO".firstLowercased == "hELLO")
    }

    // MARK: Validation

    @Test(
        "recognizes well-formed email addresses",
        arguments: ["user@example.com", "first.last+tag@sub.example.co", "a@b.io"]
    )
    func validEmails(_ email: String) {
        #expect(email.isValidEmail)
    }

    @Test(
        "rejects malformed email addresses",
        arguments: ["not-an-email", "user@", "@example.com", "user@example", ""]
    )
    func invalidEmails(_ email: String) {
        #expect(!email.isValidEmail)
    }

    // MARK: Case Styles

    @Test("camelCased normalizes separator-delimited words")
    func camelCasedBasic() {
        #expect("hello world_test".camelCased == "helloWorldTest")
    }

    @Test("camelCased on an empty string returns an empty string")
    func camelCasedEmpty() {
        #expect("".camelCased == "")
    }

    @Test("snakeCased inserts underscores at case boundaries and normalizes separators")
    func snakeCasedBasic() {
        #expect("helloWorld Test-Value".snakeCased == "hello_world_test_value")
    }

    @Test("kebabCased matches snakeCased with hyphens instead of underscores")
    func kebabCasedBasic() {
        #expect("helloWorld_test value".kebabCased == "hello-world-test-value")
    }

    // MARK: Filtering & Trimming

    @Test("onlyNumbers strips every non-digit character")
    func onlyNumbersBasic() {
        #expect("+1 (555) 123-4567".onlyNumbers == "15551234567")
    }

    @Test("onlyNumbers on a string with no digits returns an empty string")
    func onlyNumbersNoDigits() {
        #expect("abc-def".onlyNumbers == "")
    }

    @Test("trimmed removes leading and trailing whitespace and newlines")
    func trimmedBasic() {
        #expect("  \n hello \t\n".trimmed == "hello")
    }

    @Test("isBlank is true for empty and whitespace-only strings", arguments: ["", "   ", "\n\t"])
    func isBlankTrue(_ input: String) {
        #expect(input.isBlank)
    }

    @Test("isBlank is false for strings with non-whitespace content")
    func isBlankFalse() {
        #expect(!"hello".isBlank)
    }
}
