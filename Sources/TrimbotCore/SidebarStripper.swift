import Foundation

public enum SidebarStripper {
    private static let markers: Set<Character> = ["▎", "│", "┃"]

    public static func strip(_ input: String) -> String {
        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)
        let cleaned = lines.map(stripLine)
        return cleaned.joined(separator: "\n")
    }

    private static func stripLine(_ line: Substring) -> String {
        var i = line.startIndex
        var sawMarker = false
        while i < line.endIndex {
            let ch = line[i]
            if ch == " " || ch == "\t" {
                i = line.index(after: i)
            } else if markers.contains(ch) {
                sawMarker = true
                i = line.index(after: i)
            } else {
                break
            }
        }
        guard sawMarker else { return String(line) }
        if i < line.endIndex, line[i] == " " {
            i = line.index(after: i)
        }
        return String(line[i...])
    }
}
