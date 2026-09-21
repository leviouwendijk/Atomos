public struct Date:
    Sendable,
    Hashable,
    Comparable,
    Codable
{
    public let secondsSinceUnixEpoch: Int64
    public let nanoseconds: UInt32

    public init(
        secondsSinceUnixEpoch: Int64,
        nanoseconds: UInt32 = 0
    ) {
        precondition(
            nanoseconds < 1_000_000_000
        )

        self.secondsSinceUnixEpoch = secondsSinceUnixEpoch
        self.nanoseconds = nanoseconds
    }

    public init() {
        self = _AtomosSystemClock.wallDate()
    }

    public static var now: Self {
        .init()
    }

    public var timeIntervalSince1970: TimeInterval {
        Double(secondsSinceUnixEpoch)
            + Double(nanoseconds) / 1_000_000_000
    }

    public func timeIntervalSince(
        _ other: Self
    ) -> TimeInterval {
        let seconds = secondsSinceUnixEpoch
            - other.secondsSinceUnixEpoch
        let nanoseconds = Int64(nanoseconds)
            - Int64(other.nanoseconds)

        return Double(seconds)
            + Double(nanoseconds) / 1_000_000_000
    }

    public static func < (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        if lhs.secondsSinceUnixEpoch
            != rhs.secondsSinceUnixEpoch {
            return lhs.secondsSinceUnixEpoch
                < rhs.secondsSinceUnixEpoch
        }

        return lhs.nanoseconds < rhs.nanoseconds
    }
}
