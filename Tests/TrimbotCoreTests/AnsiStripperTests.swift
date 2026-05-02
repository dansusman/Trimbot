import Testing
@testable import TrimbotCore

@Suite("AnsiStripper")
struct AnsiStripperTests {
    @Test func stripsCsiSgrColor() {
        #expect(AnsiStripper.strip("\u{001B}[31mred\u{001B}[0m") == "red")
    }

    @Test func stripsCsiCursorMove() {
        #expect(AnsiStripper.strip("hi\u{001B}[2Aworld") == "hiworld")
    }

    @Test func stripsCsiWithMultipleParams() {
        #expect(AnsiStripper.strip("\u{001B}[1;31;42mbold\u{001B}[0m") == "bold")
    }

    @Test func stripsOscHyperlink() {
        #expect(AnsiStripper.strip("\u{001B}]8;;https://x.io\u{001B}\\link\u{001B}]8;;\u{001B}\\") == "link")
    }

    @Test func leavesPlainTextAlone() {
        #expect(AnsiStripper.strip("plain text 123") == "plain text 123")
    }

    @Test func preservesNewlines() {
        #expect(AnsiStripper.strip("a\nb") == "a\nb")
    }
}
