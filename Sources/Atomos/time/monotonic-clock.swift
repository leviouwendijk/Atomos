public struct MonotonicClock: Sendable {
    public struct Instant:
        Sendable,
        Hashable,
        Comparable
    {
        let nanosecondsSinceArbitraryEpoch: UInt64

        init(
            nanosecondsSinceArbitraryEpoch: UInt64
        ) {
            self.nanosecondsSinceArbitraryEpoch = nanosecondsSinceArbitraryEpoch
        }

        public func duration(
            to other: Self
        ) -> Duration {
            if other.nanosecondsSinceArbitraryEpoch
                >= nanosecondsSinceArbitraryEpoch {
                let delta = other.nanosecondsSinceArbitraryEpoch
                    - nanosecondsSinceArbitraryEpoch

                precondition(
                    delta <= UInt64(Int64.max)
                )

                return .init(
                    nanoseconds: Int64(delta)
                )
            }

            let delta = nanosecondsSinceArbitraryEpoch
                - other.nanosecondsSinceArbitraryEpoch

            precondition(
                delta <= UInt64(Int64.max)
            )

            return .init(
                nanoseconds: -Int64(delta)
            )
        }

        public static func < (
            lhs: Self,
            rhs: Self
        ) -> Bool {
            lhs.nanosecondsSinceArbitraryEpoch
                < rhs.nanosecondsSinceArbitraryEpoch
        }
    }

    public struct Duration:
        Sendable,
        Hashable,
        Comparable,
        Codable,
        CustomStringConvertible
    {
        public let nanoseconds: Int64

        public init(
            nanoseconds: Int64
        ) {
            self.nanoseconds = nanoseconds
        }

        public init(
            seconds: Double
        ) {
            self.nanoseconds = Int64(
                (seconds * 1_000_000_000).rounded()
            )
        }

        public static let zero = Self(
            nanoseconds: 0
        )

        public var microseconds: Double {
            Double(nanoseconds) / 1_000
        }

        public var milliseconds: Double {
            Double(nanoseconds) / 1_000_000
        }

        public var seconds: Double {
            Double(nanoseconds) / 1_000_000_000
        }

        public var description: String {
            "\(nanoseconds)ns"
        }

        public static func < (
            lhs: Self,
            rhs: Self
        ) -> Bool {
            lhs.nanoseconds < rhs.nanoseconds
        }

        public static func + (
            lhs: Self,
            rhs: Self
        ) -> Self {
            .init(
                nanoseconds: lhs.nanoseconds
                    + rhs.nanoseconds
            )
        }

        public static func - (
            lhs: Self,
            rhs: Self
        ) -> Self {
            .init(
                nanoseconds: lhs.nanoseconds
                    - rhs.nanoseconds
            )
        }
    }

    public init() {}

    public var now: Instant {
        .init(
            nanosecondsSinceArbitraryEpoch: _AtomosSystemClock.monotonicNanoseconds()
        )
    }
}
