# Atomos

Atomos is the foundational low-level primitives package.

## Boundary

Atomos has no external package dependencies and declares no platform floor.

Platform differences terminate inside Atomos. Higher-level packages consume portable Atomos primitives rather than depending directly on Darwin, Glibc, Musl, Bionic, WASI, WinSDK, or deployment-specific runtime APIs.

Atomos should own primitives when doing so materially improves deployment reach, semantic control, representation, or package layering.

It is not a goal to recreate or mirror Foundation indiscriminately.

## Time

Atomos currently owns monotonic elapsed-time primitives only.

- `MonotonicClock`: platform-independent monotonic clock facade.
- `MonotonicClock.Instant`: opaque instant in an arbitrary monotonic epoch.
- `MonotonicClock.Duration`: signed nanosecond duration.
- `MonotonicClock.sleep(for:)`: blocking relative sleep using the native platform sleep primitive.

The monotonic timing and sleep backends are implemented directly with native platform primitives so they do not inherit availability constraints from higher-level clock or concurrency APIs.

Wall-clock and civil-time concepts such as `Date` remain outside Atomos for now. Higher-level libraries may use Foundation directly where Foundation provides the desired portable semantics.

## Foundation interoperability

Atomos may add `#if canImport(Foundation)` extensions in the future when a concrete interoperability need exists.

Such extensions should bridge an Atomos-owned primitive to Foundation without changing the primitive's core meaning, representation, or availability.

There is intentionally no conversion between a wall-clock timestamp and `MonotonicClock.Instant`: a monotonic instant has an arbitrary epoch and is only meaningful for ordering and elapsed-time measurement within that clock domain.

## Growth rule

Add primitives to Atomos when ownership is useful in itself, not merely to replace an existing Foundation spelling.
