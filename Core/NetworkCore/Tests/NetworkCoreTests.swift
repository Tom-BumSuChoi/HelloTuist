import Foundation
import XCTest
@testable import NetworkCore
import NetworkCoreTesting
import NetworkCoreInterface

final class NetworkCoreTests: XCTestCase {
    func test_mockClient_recordsEndpoints() async throws {
        let client = MockNetworkClient()
        let jsonData = try JSONEncoder().encode(["key": "value"])
        client.mockData = jsonData

        let _: [String: String] = try await client.request(
            Endpoint(path: "/test")
        )

        XCTAssertEqual(client.requestedEndpoints.count, 1)
        XCTAssertEqual(client.requestedEndpoints.first?.path, "/test")
    }

    func test_mockClient_throwsOnError() async {
        let client = MockNetworkClient()
        client.mockError = NetworkError.noData

        do {
            let _: Data = try await client.request(Endpoint(path: "/fail"))
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? NetworkError, .noData)
        }
    }

    func test_endpoint_creation() {
        let endpoint = Endpoint(
            path: "/flights",
            method: .post,
            headers: ["Authorization": "Bearer token"]
        )
        XCTAssertEqual(endpoint.path, "/flights")
        XCTAssertEqual(endpoint.method, .post)
        XCTAssertEqual(endpoint.headers["Authorization"], "Bearer token")
    }
}
