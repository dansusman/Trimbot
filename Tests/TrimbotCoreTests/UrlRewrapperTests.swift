import Testing
@testable import TrimbotCore

@Suite("UrlRewrapper")
struct UrlRewrapperTests {
    @Test func rejoinsHttpsSplitMidPath() {
        let input = "see https://example.com/very/lo\nng/path?q=1 here"
        #expect(UrlRewrapper.rewrap(input) == "see https://example.com/very/long/path?q=1 here")
    }

    @Test func rejoinsAtSlashBoundary() {
        let input = "url: https://example.com/path/\ncontinued/file.html"
        #expect(UrlRewrapper.rewrap(input) == "url: https://example.com/path/continued/file.html")
    }

    @Test func rejoinsQueryString() {
        let input = "https://api.example.com/search?\nq=foo&page=2"
        #expect(UrlRewrapper.rewrap(input) == "https://api.example.com/search?q=foo&page=2")
    }

    @Test func leavesUrlFollowedBySentence() {
        let input = "see https://x.io\nThis is a sentence."
        #expect(UrlRewrapper.rewrap(input) == "see https://x.io\nThis is a sentence.")
    }

    @Test func leavesNonUrlLineBreaks() {
        #expect(UrlRewrapper.rewrap("hello world\nnot a url") == "hello world\nnot a url")
    }

    @Test func leavesUrlFollowedByBlankLine() {
        #expect(UrlRewrapper.rewrap("https://x.io/a\n\nnext para") == "https://x.io/a\n\nnext para")
    }
}
