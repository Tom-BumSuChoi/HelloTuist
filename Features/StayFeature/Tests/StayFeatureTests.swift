import Foundation
import XCTest
@testable import StayFeature
import StayFeatureTesting
import TravelDomainInterface

// MARK: - Test Doubles

private final class SpyStaySearchUseCase: StaySearchUseCaseType {
    var searchCallCount = 0
    var lastSearchCity: String?
    var lastSearchGuests: Int?
    var stubbedStays: [Stay] = []
    var stubbedError: Error?

    func searchStays(city: String, checkIn: Date, checkOut: Date, guests: Int) async throws -> [Stay] {
        searchCallCount += 1
        lastSearchCity = city
        lastSearchGuests = guests
        if let error = stubbedError { throw error }
        return stubbedStays
    }

    func getStayDetail(id: String) async throws -> Stay {
        StayFixtures.makeStay(id: id)
    }
}

// MARK: - ViewModel Tests

@MainActor
final class StaySearchViewModelTests: XCTestCase {
    private var useCase: SpyStaySearchUseCase!
    private var sut: StaySearchViewModel!

    override func setUp() {
        super.setUp()
        useCase = SpyStaySearchUseCase()
        sut = StaySearchViewModel(staySearchUseCase: useCase)
    }

    func test_initialState() {
        XCTAssertEqual(sut.city, "")
        XCTAssertEqual(sut.guests, 1)
        XCTAssertTrue(sut.stays.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.hasSearched)
    }

    func test_search_withEmptyCity_showsError() {
        sut.city = "  "
        sut.search()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(useCase.searchCallCount, 0)
    }

    func test_search_withInvalidDates_showsError() {
        sut.city = "Bali"
        sut.checkOut = sut.checkIn.addingTimeInterval(-86400)
        sut.search()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(useCase.searchCallCount, 0)
    }

    func test_search_success_updatesStays() async throws {
        useCase.stubbedStays = StayFixtures.sampleStays
        sut.city = "Bali"
        sut.guests = 2

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.stays.count, 3)
        XCTAssertTrue(sut.hasSearched)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(useCase.lastSearchCity, "Bali")
        XCTAssertEqual(useCase.lastSearchGuests, 2)
    }

    func test_search_failure_showsError() async throws {
        useCase.stubbedError = NSError(domain: "test", code: -1)
        sut.city = "Bali"

        sut.search()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.stays.isEmpty)
    }

    func test_numberOfNights_calculation() {
        sut.checkIn = Date()
        sut.checkOut = Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
        XCTAssertEqual(sut.numberOfNights, 5)
    }

    func test_bookStay_setsBookedId() {
        let stay = StayFixtures.makeStay(id: "ST999")
        sut.bookStay(stay)
        XCTAssertEqual(sut.bookedStayId, "ST999")
    }
}

// MARK: - Routing Tests

final class StayFeatureRoutingTests: XCTestCase {
    func test_mockRouting_capturesBookingParams() {
        let router = MockStayFeatureRouting()
        let checkIn = Date()
        let checkOut = Date().addingTimeInterval(86400 * 3)

        router.showBookingConfirmation(stayId: "ST001", checkIn: checkIn, checkOut: checkOut)

        XCTAssertEqual(router.bookingConfirmations.count, 1)
        XCTAssertEqual(router.bookingConfirmations[0].stayId, "ST001")
        XCTAssertEqual(router.bookingConfirmations[0].checkIn, checkIn)
        XCTAssertEqual(router.bookingConfirmations[0].checkOut, checkOut)
    }
}
