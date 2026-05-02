import Testing
@testable import TrimbotCore

@Suite("Cleaner")
struct CleanerTests {
    @Test func cleansAgentOutputBlock() {
        let input = """
            ▎ Here's what I found:
            ▎\u{00A0}\u{200B}
            ▎ \u{001B}[1m$ ls -la\u{001B}[0m
            ▎ # Notes
            ▎ See https://example.com/very/lo
            ng/path?q=1 for details
        """
        let expected = """
        Here's what I found:

        ls -la
        # Notes
        See https://example.com/very/long/path?q=1 for details
        """
        #expect(Cleaner.clean(input) == expected)
    }

    @Test func passesThroughPlainText() {
        #expect(Cleaner.clean("plain text") == "plain text")
    }

    @Test func emptyStringStaysEmpty() {
        #expect(Cleaner.clean("") == "")
    }

    @Test func reportsTransformation() {
        let result = Cleaner.process("    hello   ")
        #expect(result.cleaned == "hello")
        #expect(result.changed == true)
    }

    @Test func reportsNoTransformation() {
        let result = Cleaner.process("hello")
        #expect(result.changed == false)
    }
}
