import Foundation
import TravelDomainInterface
import NetworkCoreInterface

public final class FlightSearchUseCase: FlightSearchUseCaseType {
    private let networkClient: NetworkClientType

    public init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    public func searchFlights(
        from origin: String,
        to destination: String,
        date: Date,
        cabinClass: CabinClass
    ) async throws -> [Flight] {
        let formatter = ISO8601DateFormatter()
        let endpoint = Endpoint(
            path: "/v1/flights/search",
            queryItems: [
                URLQueryItem(name: "origin", value: origin),
                URLQueryItem(name: "destination", value: destination),
                URLQueryItem(name: "date", value: formatter.string(from: date)),
                URLQueryItem(name: "cabin", value: cabinClass.rawValue),
            ]
        )
        return try await networkClient.request(endpoint)
    }

    public func getFlightDetail(id: String) async throws -> Flight {
        let endpoint = Endpoint(path: "/v1/flights/\(id)")
        return try await networkClient.request(endpoint)
    }
}

public final class StaySearchUseCase: StaySearchUseCaseType {
    private let networkClient: NetworkClientType

    public init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    public func searchStays(
        city: String,
        checkIn: Date,
        checkOut: Date,
        guests: Int
    ) async throws -> [Stay] {
        let formatter = ISO8601DateFormatter()
        let endpoint = Endpoint(
            path: "/v1/stays/search",
            queryItems: [
                URLQueryItem(name: "city", value: city),
                URLQueryItem(name: "checkIn", value: formatter.string(from: checkIn)),
                URLQueryItem(name: "checkOut", value: formatter.string(from: checkOut)),
                URLQueryItem(name: "guests", value: String(guests)),
            ]
        )
        return try await networkClient.request(endpoint)
    }

    public func getStayDetail(id: String) async throws -> Stay {
        let endpoint = Endpoint(path: "/v1/stays/\(id)")
        return try await networkClient.request(endpoint)
    }
}
