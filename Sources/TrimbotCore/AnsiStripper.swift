import Foundation

public enum AnsiStripper {
    private static let pattern: NSRegularExpression = {
        let csi = "\u{001B}\\[[0-?]*[ -/]*[@-~]"
        let osc = "\u{001B}\\][^\u{0007}\u{001B}]*(?:\u{0007}|\u{001B}\\\\)"
        let other = "\u{001B}[@-Z\\\\-_]"
        return try! NSRegularExpression(pattern: "(?:\(csi))|(?:\(osc))|(?:\(other))")
    }()

    public static func strip(_ input: String) -> String {
        let range = NSRange(input.startIndex..., in: input)
        return pattern.stringByReplacingMatches(in: input, range: range, withTemplate: "")
    }
}
