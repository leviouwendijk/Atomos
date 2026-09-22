public extension MonotonicClock {
    func sleep(
        for duration: Duration
    ) {
        guard duration.nanoseconds > 0 else {
            return
        }

        _AtomosSystemClock.sleep(
            nanoseconds: UInt64(
                duration.nanoseconds
            )
        )
    }
}
