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
#error("Atomos does not yet provide a clock backend for this platform")
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

    static func wallDate() -> Date {
#if canImport(Darwin)
        var value = timeval()

        precondition(
            gettimeofday(
                &value,
                nil
            ) == 0
        )

        return Date(
            secondsSinceUnixEpoch: Int64(value.tv_sec),
            nanoseconds: UInt32(value.tv_usec) * 1_000
        )
#elseif canImport(WinSDK)
        var value = FILETIME()
        GetSystemTimeAsFileTime(
            &value
        )

        let ticks = UInt64(value.dwLowDateTime)
            | UInt64(value.dwHighDateTime) << 32
        let unixEpochOffset: UInt64 = 116_444_736_000_000_000

        precondition(
            ticks >= unixEpochOffset
        )

        let unixTicks = ticks - unixEpochOffset

        return Date(
            secondsSinceUnixEpoch: Int64(
                unixTicks / 10_000_000
            ),
            nanoseconds: UInt32(
                unixTicks % 10_000_000
            ) * 100
        )
#else
        var value = timespec()

        precondition(
            clock_gettime(
                CLOCK_REALTIME,
                &value
            ) == 0
        )

        return Date(
            secondsSinceUnixEpoch: Int64(value.tv_sec),
            nanoseconds: UInt32(value.tv_nsec)
        )
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
