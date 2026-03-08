import Foundation
import XCTest
@testable import FlightFeature
import FlightFeatureTesting
import TravelDomainInterface

// MARK: - Test Doubles

private final class SpyFlightSearchUseCase: FlightSearchUseCaseType {
    var searchCallCount = 0
    var lastSearchOrigin: String?
    var lastSearchDestination: String?
    var lastSearchCabinClass: CabinClass?
    var stubbedFlights: [Flight] = []
    var stubbedError: Error?

    func searchFlights(
        from origin: String, to destination: String,
        date: Date, cabinClass: CabinClass
    ) async throws -> [Flight] {
        searchCallCount += 1
        lastSearchOrigin = origin
        lastSearchDestination = destination
        lastSearchCabinClass = cabinClass
        if let error = stubbedError { throw error }
        return stubbedFlights
    }

    func getFlightDetail(id: String) async throws -> Flight {
        FlightFixtures.makeFlight(id: id)
    }
}

// MARK: - ViewModel Tests

@MainActor
final class FlightSearchViewModelTests: XCTestCase {
    private var useCase: SpyFlightSearchUseCase!
    private var sut: FlightSearchViewModel!

    override func setUp() {
        super.setUp()
        useCase = SpyFlightSearchUseCase()
        sut = FlightSearchViewModel(flightSearchUseCase: useCase)
    }

    func test_initialState() {
        XCTAssertEqual(sut.origin, "")
        XCTAssertEqual(sut.destination, "")
        XCTAssertEqual(sut.cabinClass, .economy)
        XCTAssertTrue(sut.flights.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.hasSearched)
    }

    func test_search_withEmptyOrigin_showsError() {
        sut.origin = ""
        sut.destination = "BKK"

        sut.search()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(useCase.searchCallCount, 0)
    }

    func test_search_withEmptyDestination_showsError() {
        sut.origin = "ICN"
        sut.destination = "  "

        sut.search()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(useCase.searchCallCount, 0)
    }

    func test_search_success_updatesFlights() async throws {
        useCase.stubbedFlights = FlightFixtures.sampleFlights
        sut.origin = "ICN"
        sut.destination = "BKK"
        sut.cabinClass = .business

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.flights.count, 3)
        XCTAssertTrue(sut.hasSearched)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(useCase.lastSearchOrigin, "ICN")
        XCTAssertEqual(useCase.lastSearchDestination, "BKK")
        XCTAssertEqual(useCase.lastSearchCabinClass, .business)
    }

    func test_search_failure_showsError() async throws {
        useCase.stubbedError = NSError(domain: "test", code: -1)
        sut.origin = "ICN"
        sut.destination = "BKK"

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.flights.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func test_search_clearsErrorOnNewSearch() async throws {
        useCase.stubbedFlights = FlightFixtures.sampleFlights
        sut.errorMessage = "이전 오류"
        sut.origin = "ICN"
        sut.destination = "BKK"

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNil(sut.errorMessage)
    }

    func test_bookFlight_setsBookedId() {
        let flight = FlightFixtures.makeFlight(id: "FL999")
        sut.bookFlight(flight)
        XCTAssertEqual(sut.bookedFlightId, "FL999")
    }
}

// MARK: - Routing Tests

final class FlightFeatureRoutingTests: XCTestCase {
    func test_mockRouting_tracksAllCalls() {
        let router = MockFlightFeatureRouting()
        router.showFlightSearch()
        router.showFlightSearch()
        router.showFlightDetail(flightId: "FL001")
        router.showBookingConfirmation(flightId: "FL002")

        XCTAssertEqual(router.showFlightSearchCallCount, 2)
        XCTAssertEqual(router.showFlightDetailIds, ["FL001"])
        XCTAssertEqual(router.showBookingConfirmationIds, ["FL002"])
    }
}
