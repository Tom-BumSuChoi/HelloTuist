import Foundation
import XCTest
@testable import TravelDomain
import TravelDomainTesting
import TravelDomainInterface

final class TravelDomainTests: XCTestCase {
    func test_flight_model() {
        let flight = Flight(
            id: "FL001",
            airline: "Korean Air",
            flightNumber: "KE001",
            departure: Airport(code: "ICN", name: "인천국제공항", city: "서울", country: "대한민국"),
            arrival: Airport(code: "NRT", name: "Narita", city: "Tokyo", country: "Japan"),
            departureTime: Date(),
            arrivalTime: Date().addingTimeInterval(7200),
            price: 350000,
            currency: "KRW",
            cabinClass: .economy
        )

        XCTAssertEqual(flight.id, "FL001")
        XCTAssertEqual(flight.departure.code, "ICN")
        XCTAssertEqual(flight.cabinClass, .economy)
    }

    func test_stay_model() {
        let stay = Stay(
            id: "ST001",
            name: "Bali Nomad Villa",
            type: .airbnb,
            address: "Jl. Raya Ubud",
            city: "Ubud",
            country: "Indonesia",
            latitude: -8.5069,
            longitude: 115.2625,
            pricePerNight: 45.0,
            currency: "USD",
            rating: 4.8,
            reviewCount: 324,
            amenities: ["WiFi", "Pool", "Kitchen"],
            imageURLs: []
        )

        XCTAssertEqual(stay.type, .airbnb)
        XCTAssertEqual(stay.city, "Ubud")
    }

    func test_mockFlightUseCase() async throws {
        let mock = MockFlightSearchUseCase()
        mock.stubbedFlights = [
            Flight(
                id: "FL001",
                airline: "Test Air",
                flightNumber: "TA100",
                departure: Airport(code: "ICN", name: "Incheon", city: "Seoul", country: "KR"),
                arrival: Airport(code: "BKK", name: "Bangkok", city: "Bangkok", country: "TH"),
                departureTime: Date(),
                arrivalTime: Date(),
                price: 200,
                currency: "USD",
                cabinClass: .economy
            ),
        ]

        let results = try await mock.searchFlights(
            from: "ICN", to: "BKK", date: Date(), cabinClass: .economy
        )
        XCTAssertEqual(results.count, 1)
    }
}
