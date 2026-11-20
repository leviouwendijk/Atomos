/// The time of day, from the system's realtime clock. It can jump (time sync, the user
/// setting it), so it dates events; `MonotonicClock` measures durations.
///
/// Injectable: `WallClock { instant }` reads a fixed or hand-moved time instead of the
/// system, for tests and replays.
public struct WallClock: Sendable {
    public struct Instant:
        Sendable,
        Hashable,
        Comparable,
        Codable,
        CustomStringConvertible
    {
        public let nanosecondsSinceUnixEpoch: Int64

        public init(
            nanosecondsSinceUnixEpoch: Int64
        ) {
            self.nanosecondsSinceUnixEpoch = nanosecondsSinceUnixEpoch
        }

        /// Rounds to the nearest nanosecond; saturates out of range, NaN becomes the epoch.
        /// Whole and fractional seconds convert apart: scaling a present-day time by 1e9 as
        /// one Double would lose its last ~100 ns to the 53-bit mantissa.
        public init(
            secondsSinceUnixEpoch seconds: Double
        ) {
            let limit = Double(Int64.max) / 1_000_000_000

            guard !seconds.isNaN else {
                self.nanosecondsSinceUnixEpoch = 0
                return
            }

            guard seconds < limit else {
                self.nanosecondsSinceUnixEpoch = .max
                return
            }

            guard seconds > -limit else {
                self.nanosecondsSinceUnixEpoch = .min
                return
            }

            let whole = seconds.rounded(.towardZero)
            let fraction = Int64(
                ((seconds - whole) * 1_000_000_000).rounded()
            )
            let (value, overflow) = (Int64(whole) * 1_000_000_000)
                .addingReportingOverflow(fraction)

            self.nanosecondsSinceUnixEpoch = overflow
                ? (fraction > 0 ? .max : .min)
                : value
        }

        /// Whole and fractional seconds convert apart, as in `init(secondsSinceUnixEpoch:)`.
        public var secondsSinceUnixEpoch: Double {
            Double(nanosecondsSinceUnixEpoch / 1_000_000_000)
                + Double(nanosecondsSinceUnixEpoch % 1_000_000_000) / 1_000_000_000
        }

        /// Negative when `other` is earlier. Saturates.
        public func duration(
            to other: Self
        ) -> MonotonicClock.Duration {
            MonotonicClock.Duration(nanoseconds: other.nanosecondsSinceUnixEpoch)
                - MonotonicClock.Duration(nanoseconds: nanosecondsSinceUnixEpoch)
        }

        /// Saturating.
        public static func + (
            lhs: Self,
            rhs: MonotonicClock.Duration
        ) -> Self {
            .init(
                nanosecondsSinceUnixEpoch: (
                    MonotonicClock.Duration(nanoseconds: lhs.nanosecondsSinceUnixEpoch) + rhs
                ).nanoseconds
            )
        }

        public static func < (
            lhs: Self,
            rhs: Self
        ) -> Bool {
            lhs.nanosecondsSinceUnixEpoch < rhs.nanosecondsSinceUnixEpoch
        }

        public var description: String {
            "\(nanosecondsSinceUnixEpoch)ns since 1970"
        }
    }

    private let read: @Sendable () -> Instant

    public init() {
        self.read = {
            .init(
                nanosecondsSinceUnixEpoch: _AtomosSystemClock.realtimeNanoseconds()
            )
        }
    }

    /// A clock that reads `read` instead of the system.
    public init(
        _ read: @escaping @Sendable () -> Instant
    ) {
        self.read = read
    }

    public static let system = WallClock()

    public var now: Instant {
        read()
    }
}
