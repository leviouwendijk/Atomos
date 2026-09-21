#if canImport(Darwin)
import Darwin
#elseif canImport(WinSDK)
import WinSDK
#elseif canImport(Bionic)
import Bionic
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(WASILibc)
import WASILibc
#else
#error("Atomos does not yet provide a monotonic clock backend for this platform")
#endif

internal enum _AtomosSystemClock {
    static func monotonicNanoseconds() -> UInt64 {
#if canImport(Darwin)
        let ticks = mach_absolute_time()
        let numerator = UInt64(
            darwinTimebase.numer
        )
        let denominator = UInt64(
            darwinTimebase.denom
        )

        let whole = ticks / denominator
        let remainder = ticks % denominator

        return whole * numerator
            + remainder * numerator / denominator
#elseif canImport(WinSDK)
        var counter = LARGE_INTEGER()
        var frequency = LARGE_INTEGER()

        precondition(
            QueryPerformanceCounter(&counter).boolValue
        )
        precondition(
            QueryPerformanceFrequency(&frequency).boolValue
        )

        let ticks = UInt64(counter.QuadPart)
        let ticksPerSecond = UInt64(frequency.QuadPart)
        let seconds = ticks / ticksPerSecond
        let remainder = ticks % ticksPerSecond

        return seconds * 1_000_000_000
            + remainder * 1_000_000_000 / ticksPerSecond
#else
        var value = timespec()

        precondition(
            clock_gettime(
                CLOCK_MONOTONIC,
                &value
            ) == 0
        )

        return UInt64(value.tv_sec) * 1_000_000_000
            + UInt64(value.tv_nsec)
#endif
    }
}

#if canImport(Darwin)
private let darwinTimebase: mach_timebase_info_data_t = {
    var value = mach_timebase_info_data_t()

    precondition(
        mach_timebase_info(&value) == KERN_SUCCESS
    )

    return value
}()
#endif
