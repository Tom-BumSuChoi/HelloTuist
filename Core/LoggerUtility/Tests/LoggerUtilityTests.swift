import Foundation
import XCTest
@testable import LoggerUtility
import LoggerUtilityTesting
import LoggerUtilityInterface

final class LoggerUtilityTests: XCTestCase {
    func test_mockLogger_recordsMessages() {
        let logger = MockLogger()
        logger.info("Test message")
        logger.error("Error occurred")

        XCTAssertEqual(logger.loggedMessages.count, 2)
        XCTAssertEqual(logger.loggedMessages[0].level, .info)
        XCTAssertEqual(logger.loggedMessages[0].message, "Test message")
        XCTAssertEqual(logger.loggedMessages[1].level, .error)
    }

    func test_logLevel_comparison() {
        XCTAssertTrue(LogLevel.debug < LogLevel.info)
        XCTAssertTrue(LogLevel.warning < LogLevel.error)
        XCTAssertTrue(LogLevel.error < LogLevel.fatal)
    }
}
