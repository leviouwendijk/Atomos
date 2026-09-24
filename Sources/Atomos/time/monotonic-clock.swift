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

        /// Builds a duration from floating-point seconds without trapping.
        ///
        /// Finite values are rounded to the nearest nanosecond. Values outside
        /// the representable range saturate. Infinity saturates toward its sign;
        /// NaN normalizes to zero.
        public init(
            seconds: Double
        ) {
            guard !seconds.isNaN else {
                self.nanoseconds = 0
                return
            }

            let scaled = seconds * 1_000_000_000

            if scaled >= Double(Int64.max) {
                self.nanoseconds = .max
                return
            }

            if scaled <= Double(Int64.min) {
                self.nanoseconds = .min
                return
            }

            self.nanoseconds = Int64(
                scaled.rounded()
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

        /// Saturating addition.
        public static func + (
            lhs: Self,
            rhs: Self
        ) -> Self {
            let (value, overflow) = lhs.nanoseconds.addingReportingOverflow(
                rhs.nanoseconds
            )

            guard overflow else {
                return .init(nanoseconds: value)
            }

            return .init(
                nanoseconds: lhs.nanoseconds >= 0 ? .max : .min
            )
        }

        /// Saturating subtraction.
        public static func - (
            lhs: Self,
            rhs: Self
        ) -> Self {
            let (value, overflow) = lhs.nanoseconds.subtractingReportingOverflow(
                rhs.nanoseconds
            )

            guard overflow else {
                return .init(nanoseconds: value)
            }

            return .init(
                nanoseconds: rhs.nanoseconds < 0 ? .max : .min
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
