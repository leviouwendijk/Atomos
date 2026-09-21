#if canImport(Foundation)
import Foundation

internal enum _AtomosFoundationClock {
    static func wallDate() -> Date {
        Date(
            timeIntervalSince1970: Foundation.Date()
                .timeIntervalSince1970
        )
    }
}

public extension Date {
    init(
        _ foundation: Foundation.Date
    ) {
        self.init(
            timeIntervalSince1970: foundation.timeIntervalSince1970
        )
    }

    var foundation: Foundation.Date {
        Foundation.Date(
            timeIntervalSince1970: timeIntervalSince1970
        )
    }
}
#endif
