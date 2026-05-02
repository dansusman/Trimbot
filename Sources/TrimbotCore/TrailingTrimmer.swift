import Foundation

public enum TrailingTrimmer {
    public static func trim(_ input: String) -> String {
        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)
        let trimmed = lines.map { line -> String in
            var end = line.endIndex
            while end > line.startIndex {
                let prev = line.index(before: end)
                let ch = line[prev]
                if ch == " " || ch == "\t" { end = prev } else { break }
            }
            return String(line[line.startIndex..<end])
        }
        return trimmed.joined(separator: "\n")
    }
}
