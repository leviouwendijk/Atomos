# Atomos

Atomos is the foundational platform-primitives package.

## Boundary

Atomos must remain free of Foundation and external package dependencies. It declares no platform floor.

Platform differences terminate inside Atomos. Higher-level packages consume portable Swift values rather than Darwin, Glibc, Musl, Bionic, WASI, or WinSDK APIs directly.

## Initial primitives

- `Date`: wall-clock UTC time represented as seconds and nanoseconds since the Unix epoch.
- `TimeInterval`: transitional scalar interval representation.
- `MonotonicClock`: monotonic interval clock backed directly by the native platform clock.
- `MonotonicClock.Instant`: opaque monotonic instant.
- `MonotonicClock.Duration`: signed nanosecond duration.

Atomos is intended to grow only when a broadly reusable primitive would otherwise force Foundation or platform-specific APIs into higher-level libraries.
