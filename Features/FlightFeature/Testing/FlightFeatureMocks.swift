import Foundation
import FlightFeatureInterface
import TravelDomainInterface

public final class MockFlightFeatureRouting: FlightFeatureRouting {
    public var showFlightSearchCallCount = 0
    public var showFlightDetailIds: [String] = []
    public var showBookingConfirmationIds: [String] = []

    public init() {}

    public func showFlightSearch() {
        showFlightSearchCallCount += 1
    }

    public func showFlightDetail(flightId: String) {
        showFlightDetailIds.append(flightId)
    }

    public func showBookingConfirmation(flightId: String) {
        showBookingConfirmationIds.append(flightId)
    }
}

public enum FlightFixtures {
    public static let sampleAirports = (
        icn: Airport(code: "ICN", name: "인천국제공항", city: "서울", country: "대한민국"),
        bkk: Airport(code: "BKK", name: "수완나품국제공항", city: "방콕", country: "태국"),
        nrt: Airport(code: "NRT", name: "나리타국제공항", city: "도쿄", country: "일본")
    )

    public static func makeFlight(
        id: String = "FL001",
        airline: String = "Korean Air",
        flightNumber: String = "KE653",
        departure: Airport? = nil,
        arrival: Airport? = nil,
        price: Decimal = 450000,
        currency: String = "KRW",
        cabinClass: CabinClass = .economy
    ) -> Flight {
        Flight(
            id: id,
            airline: airline,
            flightNumber: flightNumber,
            departure: departure ?? sampleAirports.icn,
            arrival: arrival ?? sampleAirports.bkk,
            departureTime: Date(),
            arrivalTime: Date().addingTimeInterval(18000),
            price: price,
            currency: currency,
            cabinClass: cabinClass
        )
    }

    public static let sampleFlights: [Flight] = [
        makeFlight(),
        makeFlight(id: "FL002", airline: "Thai Airways", flightNumber: "TG659", price: 380000),
        makeFlight(id: "FL003", airline: "Asiana", flightNumber: "OZ741", price: 420000),
    ]
}
