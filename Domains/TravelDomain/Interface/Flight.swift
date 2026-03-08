import Foundation

public struct Flight: Codable, Equatable, Identifiable {
    public let id: String
    public let airline: String
    public let flightNumber: String
    public let departure: Airport
    public let arrival: Airport
    public let departureTime: Date
    public let arrivalTime: Date
    public let price: Decimal
    public let currency: String
    public let cabinClass: CabinClass

    public init(
        id: String,
        airline: String,
        flightNumber: String,
        departure: Airport,
        arrival: Airport,
        departureTime: Date,
        arrivalTime: Date,
        price: Decimal,
        currency: String,
        cabinClass: CabinClass
    ) {
        self.id = id
        self.airline = airline
        self.flightNumber = flightNumber
        self.departure = departure
        self.arrival = arrival
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.price = price
        self.currency = currency
        self.cabinClass = cabinClass
    }
}

public struct Airport: Codable, Equatable {
    public let code: String
    public let name: String
    public let city: String
    public let country: String

    public init(code: String, name: String, city: String, country: String) {
        self.code = code
        self.name = name
        self.city = city
        self.country = country
    }
}

public enum CabinClass: String, Codable, CaseIterable {
    case economy
    case premiumEconomy
    case business
    case first
}
