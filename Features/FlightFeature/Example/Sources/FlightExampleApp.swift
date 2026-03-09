import SwiftUI
import FlightFeature
import FlightFeatureTesting
import TravelDomainInterface

@main
struct FlightExampleApp: App {
    var body: some Scene {
        WindowGroup {
            FlightSearchView(flightSearchUseCase: PreviewFlightSearchUseCase())
        }
    }
}

private final class PreviewFlightSearchUseCase: FlightSearchUseCaseType {
    func searchFlights(
        from origin: String,
        to destination: String,
        date: Date,
        cabinClass: CabinClass
    ) async throws -> [Flight] {
        [
            Flight(
                id: "FL001",
                airline: "Korean Air",
                flightNumber: "KE653",
                departure: Airport(code: "ICN", name: "인천", city: "서울", country: "KR"),
                arrival: Airport(code: "BKK", name: "수완나품", city: "방콕", country: "TH"),
                departureTime: Date(),
                arrivalTime: Date().addingTimeInterval(18000),
                price: 450000,
                currency: "KRW",
                cabinClass: .economy
            ),
            Flight(
                id: "FL002",
                airline: "Thai Airways",
                flightNumber: "TG659",
                departure: Airport(code: "ICN", name: "인천", city: "서울", country: "KR"),
                arrival: Airport(code: "BKK", name: "수완나품", city: "방콕", country: "TH"),
                departureTime: Date(),
                arrivalTime: Date().addingTimeInterval(19800),
                price: 380000,
                currency: "KRW",
                cabinClass: .economy
            ),
        ]
    }

    func getFlightDetail(id: String) async throws -> Flight {
        Flight(
            id: id,
            airline: "Korean Air",
            flightNumber: "KE653",
            departure: Airport(code: "ICN", name: "인천", city: "서울", country: "KR"),
            arrival: Airport(code: "BKK", name: "수완나품", city: "방콕", country: "TH"),
            departureTime: Date(),
            arrivalTime: Date().addingTimeInterval(18000),
            price: 450000,
            currency: "KRW",
            cabinClass: .economy
        )
    }
}
