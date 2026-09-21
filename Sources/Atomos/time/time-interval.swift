#if canImport(Foundation)
import Foundation

public typealias TimeInterval = Foundation.TimeInterval
#else
public typealias TimeInterval = Double
#endif
