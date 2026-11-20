import Atomos

private func require(
    _ condition: @autoclosure () -> Bool,
    _ name: String
) {
    guard condition() else {
        fatalError("tatomos_time failed: \(name)")
    }
}

let maximum = MonotonicClock.Duration(nanoseconds: .max)
let minimum = MonotonicClock.Duration(nanoseconds: .min)
let one = MonotonicClock.Duration(nanoseconds: 1)

require(
    MonotonicClock.Duration(seconds: .infinity).nanoseconds == .max,
    "positive infinity saturates"
)
require(
    MonotonicClock.Duration(seconds: -.infinity).nanoseconds == .min,
    "negative infinity saturates"
)
require(
    MonotonicClock.Duration(seconds: .nan).nanoseconds == 0,
    "NaN normalizes to zero"
)
require(
    MonotonicClock.Duration(seconds: Double.greatestFiniteMagnitude).nanoseconds == .max,
    "huge positive finite value saturates"
)
require(
    MonotonicClock.Duration(seconds: -Double.greatestFiniteMagnitude).nanoseconds == .min,
    "huge negative finite value saturates"
)
require(
    (maximum + one).nanoseconds == .max,
    "addition saturates at maximum"
)
require(
    (minimum - one).nanoseconds == .min,
    "subtraction saturates at minimum"
)
require(
    (minimum + MonotonicClock.Duration(nanoseconds: -1)).nanoseconds == .min,
    "negative addition saturates at minimum"
)
require(
    (maximum - MonotonicClock.Duration(nanoseconds: -1)).nanoseconds == .max,
    "subtracting a negative duration saturates at maximum"
)
require(
    (MonotonicClock.Duration(nanoseconds: 40) + MonotonicClock.Duration(nanoseconds: 2)).nanoseconds == 42,
    "ordinary addition remains exact"
)
require(
    (MonotonicClock.Duration(nanoseconds: 40) - MonotonicClock.Duration(nanoseconds: 2)).nanoseconds == 38,
    "ordinary subtraction remains exact"
)


let epoch = WallClock.Instant(nanosecondsSinceUnixEpoch: 0)
let later = WallClock.Instant(secondsSinceUnixEpoch: 1.5)

require(
    later.nanosecondsSinceUnixEpoch == 1_500_000_000,
    "wall instant from seconds"
)
require(
    epoch.duration(to: later).nanoseconds == 1_500_000_000,
    "wall duration forward"
)
require(
    later.duration(to: epoch).nanoseconds == -1_500_000_000,
    "wall duration backward"
)
require(
    epoch + MonotonicClock.Duration(seconds: 1.5) == later,
    "wall instant plus duration"
)
require(
    (WallClock.Instant(nanosecondsSinceUnixEpoch: .max) + one).nanosecondsSinceUnixEpoch == .max,
    "wall addition saturates"
)
require(
    WallClock { later }.now == later,
    "an injected clock reads its closure"
)

let present = WallClock.Instant(nanosecondsSinceUnixEpoch: 1_700_000_000_123_456_789)

require(
    WallClock.Instant(secondsSinceUnixEpoch: 1_700_000_000.25).nanosecondsSinceUnixEpoch
        == 1_700_000_000_250_000_000,
    "present-day seconds convert without losing nanoseconds"
)
require(
    abs(
        WallClock.Instant(secondsSinceUnixEpoch: present.secondsSinceUnixEpoch)
            .nanosecondsSinceUnixEpoch - present.nanosecondsSinceUnixEpoch
    ) < 1_000,
    "a present-day instant survives seconds within a microsecond"
)
require(
    WallClock.Instant(secondsSinceUnixEpoch: -1.5).nanosecondsSinceUnixEpoch == -1_500_000_000
        && WallClock.Instant(nanosecondsSinceUnixEpoch: -1_500_000_000).secondsSinceUnixEpoch == -1.5,
    "times before 1970 convert both ways"
)
require(
    WallClock.Instant(secondsSinceUnixEpoch: .infinity).nanosecondsSinceUnixEpoch == .max
        && WallClock.Instant(secondsSinceUnixEpoch: -.infinity).nanosecondsSinceUnixEpoch == .min
        && WallClock.Instant(secondsSinceUnixEpoch: .nan).nanosecondsSinceUnixEpoch == 0,
    "out-of-range seconds saturate, NaN is the epoch"
)

require(
    WallClock.Instant(secondsSinceUnixEpoch: -9_223_372_036.5).nanosecondsSinceUnixEpoch
        == -9_223_372_036_500_000_000,
    "seconds near the negative limit convert without trapping"
)

let system = WallClock.system.now
require(
    system.secondsSinceUnixEpoch > 1_700_000_000,
    "the system clock reads the current time"
)

print("tatomos_time: 23/23 passed")
