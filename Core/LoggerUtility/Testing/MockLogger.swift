import Foundation
import LoggerUtilityInterface

public final class MockLogger: LoggerType {
    public var loggedMessages: [(level: LogLevel, message: String)] = []

    public init() {}

    public func log(_ level: LogLevel, _ message: String, file: String, function: String, line: Int) {
        loggedMessages.append((level: level, message: message))
    }
}
