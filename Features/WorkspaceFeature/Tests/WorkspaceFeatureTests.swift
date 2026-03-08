import Foundation
import XCTest
@testable import WorkspaceFeature
import WorkspaceFeatureTesting
import WorkspaceFeatureInterface
import NetworkCoreInterface

// MARK: - Test Doubles

private final class StubNetworkClient: NetworkClientType {
    var stubbedResult: Any?
    var stubbedError: Error?
    var requestCallCount = 0
    var lastEndpointPath: String?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        requestCallCount += 1
        lastEndpointPath = endpoint.path
        if let error = stubbedError { throw error }
        guard let result = stubbedResult as? T else { throw NetworkError.decodingFailed }
        return result
    }

    func request(_ endpoint: Endpoint) async throws -> Data {
        requestCallCount += 1
        if let error = stubbedError { throw error }
        return Data()
    }
}

// MARK: - ViewModel Tests

@MainActor
final class WorkspaceSearchViewModelTests: XCTestCase {
    private var networkClient: StubNetworkClient!
    private var sut: WorkspaceSearchViewModel!

    override func setUp() {
        super.setUp()
        networkClient = StubNetworkClient()
        sut = WorkspaceSearchViewModel(networkClient: networkClient)
    }

    func test_initialState() {
        XCTAssertEqual(sut.city, "")
        XCTAssertTrue(sut.spaces.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.hasSearched)
        XCTAssertNil(sut.bookedSpaceId)
    }

    func test_search_withEmptyCity_showsError() {
        sut.city = "  "
        sut.search()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(networkClient.requestCallCount, 0)
    }

    func test_search_success() async throws {
        networkClient.stubbedResult = WorkspaceFixtures.sampleSpaces
        sut.city = "Bangkok"

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.spaces.count, 3)
        XCTAssertTrue(sut.hasSearched)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(networkClient.lastEndpointPath?.contains("workspaces") ?? false)
    }

    func test_search_failure_showsError() async throws {
        networkClient.stubbedError = NetworkError.noData
        sut.city = "Bangkok"

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.spaces.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func test_search_clearsErrorOnNewSearch() async throws {
        networkClient.stubbedResult = WorkspaceFixtures.sampleSpaces
        sut.errorMessage = "이전 오류"
        sut.city = "Bangkok"

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNil(sut.errorMessage)
    }

    func test_bookDayPass_setsId() {
        let space = WorkspaceFixtures.makeSpace(id: "WS999")
        sut.bookDayPass(space)
        XCTAssertEqual(sut.bookedSpaceId, "WS999")
    }
}

// MARK: - Model Tests

final class CoworkingSpaceModelTests: XCTestCase {
    func test_coworkingSpace_properties() {
        let space = WorkspaceFixtures.makeSpace()
        XCTAssertEqual(space.id, "WS001")
        XCTAssertEqual(space.wifiSpeed, 200)
        XCTAssertEqual(space.amenities.count, 5)
    }

    func test_coworkingSpace_equatable() {
        let a = WorkspaceFixtures.makeSpace(id: "WS001")
        let b = WorkspaceFixtures.makeSpace(id: "WS001")
        XCTAssertEqual(a, b)
    }
}

// MARK: - Routing Tests

final class WorkspaceRoutingTests: XCTestCase {
    func test_mockRouting_tracksAll() {
        let router = MockWorkspaceFeatureRouting()
        router.showWorkspaceSearch()
        router.showWorkspaceDetail(workspaceId: "WS001")
        router.showDayPassBooking(workspaceId: "WS002")

        XCTAssertEqual(router.showWorkspaceSearchCallCount, 1)
        XCTAssertEqual(router.showWorkspaceDetailIds, ["WS001"])
        XCTAssertEqual(router.showDayPassBookingIds, ["WS002"])
    }
}
