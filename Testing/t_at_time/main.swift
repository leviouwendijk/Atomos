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

print("tatomos_time: 11/11 passed")
