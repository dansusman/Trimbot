import Foundation

public enum UrlRewrapper {
    private static let urlAtLineEnd: NSRegularExpression =
        try! NSRegularExpression(pattern: #"https?://[^\s]+$"#)

    public static func rewrap(_ input: String) -> String {
        var lines = input.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        guard lines.count > 1 else { return input }

        var i = 0
        while i < lines.count - 1 {
            if shouldJoin(lines[i], next: lines[i + 1]) {
                let nextTrimmed = lines[i + 1].drop { $0 == " " || $0 == "\t" }
                lines[i] = lines[i] + String(nextTrimmed)
                lines.remove(at: i + 1)
            } else {
                i += 1
            }
        }
        return lines.joined(separator: "\n")
    }

    static func shouldJoin(_ line: String, next: String) -> Bool {
        guard endsWithUrl(line) else { return false }
        let trimmed = next.drop { $0 == " " || $0 == "\t" }
        guard let first = trimmed.first else { return false }
        return isUrlContinuation(first)
    }

    private static func endsWithUrl(_ line: String) -> Bool {
        let range = NSRange(line.startIndex..., in: line)
        return urlAtLineEnd.firstMatch(in: line, range: range) != nil
    }

    private static func isUrlContinuation(_ ch: Character) -> Bool {
        if ch.isLetter { return ch.isLowercase }
        if ch.isNumber { return true }
        return "/?&=#%+-_.,;:@~".contains(ch)
    }
}
