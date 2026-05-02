import Testing
@testable import TrimbotCore

@Suite("InvisibleStripper")
struct InvisibleStripperTests {
    @Test func stripsZeroWidthSpace() {
        #expect(InvisibleStripper.strip("hi\u{200B}there") == "hithere")
    }

    @Test func stripsZwjAndZwnj() {
        #expect(InvisibleStripper.strip("a\u{200C}b\u{200D}c") == "abc")
    }

    @Test func stripsBomAndWordJoiner() {
        #expect(InvisibleStripper.strip("\u{FEFF}hello\u{2060}world") == "helloworld")
    }

    @Test func stripsSoftHyphen() {
        #expect(InvisibleStripper.strip("co\u{00AD}operate") == "cooperate")
    }

    @Test func convertsNbspToSpace() {
        #expect(InvisibleStripper.strip("a\u{00A0}b\u{202F}c") == "a b c")
    }

    @Test func keepsRegularNewlinesAndSpaces() {
        #expect(InvisibleStripper.strip("line one\nline two") == "line one\nline two")
    }
}
