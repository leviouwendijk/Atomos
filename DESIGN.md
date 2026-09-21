# Atomos

Atomos is the foundational platform-primitives package.

## Boundary

Atomos has no external package dependencies and declares no platform floor.

Atomos owns its public primitive contracts. A system or standard library such as Foundation may be conditionally imported as an implementation or interoperability backend when available, but its availability must not change the meaning or shape of the Atomos API.

Platform differences terminate inside Atomos. Higher-level packages consume portable Atomos values rather than Darwin, Glibc, Musl, Bionic, WASI, WinSDK, or deployment-specific runtime APIs directly.

## Foundation policy

Foundation is not prohibited.

When `Foundation` can be imported, Atomos may reuse mature portable Foundation implementations or provide explicit bridges to Foundation values.

This must not make Foundation availability a requirement for compiling Atomos, and must not impose an Apple deployment floor on Atomos consumers.

Atomos-owned primitives remain stable across both branches. In particular, `Date`, `MonotonicClock`, `MonotonicClock.Instant`, and `MonotonicClock.Duration` remain Atomos types whether Foundation is present or absent.

Simple aliases whose contracts are genuinely identical may map directly to Foundation. `TimeInterval` therefore aliases `Foundation.TimeInterval` when Foundation exists and falls back to `Double` otherwise.

## Initial primitives

- `Date`: wall-clock UTC time represented as seconds and nanoseconds since the Unix epoch. Foundation supplies the preferred wall-clock backend and explicit interoperability when available; a native system-clock backend remains available otherwise.
- `TimeInterval`: scalar seconds representation, mapped to `Foundation.TimeInterval` when available and `Double` otherwise.
- `MonotonicClock`: Atomos-owned monotonic interval clock backed directly by the native platform clock so it carries no deployment floor from higher-level clock APIs.
- `MonotonicClock.Instant`: opaque monotonic instant.
- `MonotonicClock.Duration`: signed nanosecond duration.

## Growth rule

Atomos should grow when owning a broadly reusable primitive improves deployment reach, semantic control, representation, interoperability, or package layering.

It is not a goal to recreate Foundation indiscriminately. Higher-level libraries may continue to import Foundation directly where Foundation already provides the desired portable semantics without undesirable deployment or layering constraints.
