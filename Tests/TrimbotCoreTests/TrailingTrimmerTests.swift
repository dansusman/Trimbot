import Testing
@testable import TrimbotCore

@Suite("TrailingTrimmer")
struct TrailingTrimmerTests {
    @Test func trimsSpaces() {
        #expect(TrailingTrimmer.trim("hello   ") == "hello")
    }

    @Test func trimsTabs() {
        #expect(TrailingTrimmer.trim("hello\t\t") == "hello")
    }

    @Test func perLine() {
        #expect(TrailingTrimmer.trim("a   \nb\t") == "a\nb")
    }

    @Test func keepsLeadingWhitespace() {
        #expect(TrailingTrimmer.trim("  hi   ") == "  hi")
    }

    @Test func leavesEmptyLines() {
        #expect(TrailingTrimmer.trim("a\n\nb") == "a\n\nb")
    }
}
