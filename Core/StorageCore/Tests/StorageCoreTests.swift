import Foundation
import XCTest
@testable import StorageCore
import StorageCoreTesting

final class StorageCoreTests: XCTestCase {
    func test_saveAndLoad() throws {
        let client = MockStorageClient()
        try client.save("hello", forKey: "greeting")
        let loaded: String? = try client.load(forKey: "greeting")
        XCTAssertEqual(loaded, "hello")
    }

    func test_delete() throws {
        let client = MockStorageClient()
        try client.save(42, forKey: "number")
        XCTAssertTrue(client.exists(forKey: "number"))
        client.delete(forKey: "number")
        XCTAssertFalse(client.exists(forKey: "number"))
    }

    func test_loadNonExistentKey() throws {
        let client = MockStorageClient()
        let result: String? = try client.load(forKey: "missing")
        XCTAssertNil(result)
    }
}
