# Atomos

Atomos is the foundational platform-primitives package.

## Boundary

Atomos has no external package dependencies and declares no platform floor.

Platform differences terminate inside Atomos. Higher-level packages consume portable Atomos vocabulary rather than depending directly on Darwin, Glibc, Musl, Bionic, WASI, WinSDK, or deployment-specific runtime APIs.

## Foundation policy

Foundation is not prohibited.

When `Foundation` can be imported and already provides the desired portable primitive semantics, Atomos may map its public vocabulary directly onto the corresponding Foundation type.

When Foundation is unavailable, Atomos may provide its own implementation of that primitive.

This allows higher-level libraries to use Atomos as a common low-level vocabulary without forcing needless wrapper types or Foundation-to-Atomos conversion at package boundaries.

A conditional Foundation mapping must not impose an Apple deployment floor on Atomos consumers.

## Initial primitives

- `Date`: aliases `Foundation.Date` whenever Foundation is available. When Foundation is unavailable, Atomos provides a compatible wall-clock value based on seconds and nanoseconds since the Unix epoch.
- `TimeInterval`: aliases `Foundation.TimeInterval` whenever Foundation is available and falls back to `Double` otherwise.
- `MonotonicClock`: remains Atomos-owned on every platform. It is backed directly by the native platform monotonic clock so it does not inherit deployment availability from higher-level Swift clock APIs.
- `MonotonicClock.Instant`: opaque monotonic instant owned by Atomos.
- `MonotonicClock.Duration`: signed nanosecond duration owned by Atomos.

## Ownership rule

Types whose semantics and type identity are already suitable may be aliases when the providing module exists.

Types where Atomos needs stronger deployment reach, representation control, or semantics remain Atomos-owned regardless of Foundation availability.

`MonotonicClock` is intentionally in the latter category because its purpose is to provide a stable monotonic timing primitive without a higher platform floor.

## Growth rule

Atomos should grow when a broadly reusable primitive improves deployment reach, semantic control, interoperability, or package layering.

It is not a goal to recreate Foundation indiscriminately.
