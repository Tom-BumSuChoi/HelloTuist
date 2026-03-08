import Foundation

public protocol FlightSearchUseCaseType {
    func searchFlights(
        from origin: String,
        to destination: String,
        date: Date,
        cabinClass: CabinClass
    ) async throws -> [Flight]

    func getFlightDetail(id: String) async throws -> Flight
}

public protocol StaySearchUseCaseType {
    func searchStays(
        city: String,
        checkIn: Date,
        checkOut: Date,
        guests: Int
    ) async throws -> [Stay]

    func getStayDetail(id: String) async throws -> Stay
}
