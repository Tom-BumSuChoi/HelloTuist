import Foundation
import TravelDomainInterface

public final class MockFlightSearchUseCase: FlightSearchUseCaseType {
    public var stubbedFlights: [Flight] = []
    public var stubbedFlight: Flight?
    public var error: Error?

    public init() {}

    public func searchFlights(
        from origin: String,
        to destination: String,
        date: Date,
        cabinClass: CabinClass
    ) async throws -> [Flight] {
        if let error { throw error }
        return stubbedFlights
    }

    public func getFlightDetail(id: String) async throws -> Flight {
        if let error { throw error }
        guard let flight = stubbedFlight ?? stubbedFlights.first(where: { $0.id == id }) else {
            throw NetworkCoreInterfaceError.notFound
        }
        return flight
    }
}

public final class MockStaySearchUseCase: StaySearchUseCaseType {
    public var stubbedStays: [Stay] = []
    public var stubbedStay: Stay?
    public var error: Error?

    public init() {}

    public func searchStays(
        city: String,
        checkIn: Date,
        checkOut: Date,
        guests: Int
    ) async throws -> [Stay] {
        if let error { throw error }
        return stubbedStays
    }

    public func getStayDetail(id: String) async throws -> Stay {
        if let error { throw error }
        guard let stay = stubbedStay ?? stubbedStays.first(where: { $0.id == id }) else {
            throw NetworkCoreInterfaceError.notFound
        }
        return stay
    }
}

private enum NetworkCoreInterfaceError: Error {
    case notFound
}
