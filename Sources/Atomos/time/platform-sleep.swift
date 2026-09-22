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
#error("Atomos does not yet provide a sleep backend for this platform")
#endif

extension _AtomosSystemClock {
    static func sleep(
        nanoseconds: UInt64
    ) {
        guard nanoseconds > 0 else {
            return
        }

#if canImport(WinSDK)
        var milliseconds = nanoseconds / 1_000_000

        if nanoseconds % 1_000_000 != 0 {
            milliseconds += 1
        }

        let maximumChunk = UInt64(
            UInt32.max
        )

        while milliseconds > maximumChunk {
            Sleep(
                UInt32.max
            )
            milliseconds -= maximumChunk
        }

        Sleep(
            DWORD(milliseconds)
        )
#else
        var request = timespec()
        request.tv_sec = numericCast(
            nanoseconds / 1_000_000_000
        )
        request.tv_nsec = numericCast(
            nanoseconds % 1_000_000_000
        )

        var remainder = timespec()

        while nanosleep(
            &request,
            &remainder
        ) != 0 {
            precondition(
                errno == EINTR
            )

            request = remainder
        }
#endif
    }
}
