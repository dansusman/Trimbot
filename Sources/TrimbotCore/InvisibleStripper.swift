import Foundation

public enum InvisibleStripper {
    private static let removed: Set<Unicode.Scalar> = [
        "\u{200B}",
        "\u{200C}",
        "\u{200D}",
        "\u{FEFF}",
        "\u{2060}",
        "\u{00AD}",
    ]

    private static let toSpace: Set<Unicode.Scalar> = [
        "\u{00A0}",
        "\u{202F}",
    ]

    public static func strip(_ input: String) -> String {
        var scalars = String.UnicodeScalarView()
        scalars.reserveCapacity(input.unicodeScalars.count)
        for scalar in input.unicodeScalars {
            if removed.contains(scalar) { continue }
            if toSpace.contains(scalar) { scalars.append(" "); continue }
            scalars.append(scalar)
        }
        return String(scalars)
    }
}
