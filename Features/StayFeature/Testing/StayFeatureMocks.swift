import Foundation
import StayFeatureInterface
import TravelDomainInterface

public final class MockStayFeatureRouting: StayFeatureRouting {
    public var showStaySearchCallCount = 0
    public var showStayDetailIds: [String] = []
    public var bookingConfirmations: [(stayId: String, checkIn: Date, checkOut: Date)] = []

    public init() {}

    public func showStaySearch() {
        showStaySearchCallCount += 1
    }

    public func showStayDetail(stayId: String) {
        showStayDetailIds.append(stayId)
    }

    public func showBookingConfirmation(stayId: String, checkIn: Date, checkOut: Date) {
        bookingConfirmations.append((stayId: stayId, checkIn: checkIn, checkOut: checkOut))
    }
}

public enum StayFixtures {
    public static func makeStay(
        id: String = "ST001",
        name: String = "Ubud Nomad Villa",
        type: StayType = .airbnb,
        city: String = "Ubud",
        country: String = "Indonesia",
        pricePerNight: Decimal = 45,
        currency: String = "USD",
        rating: Double = 4.8,
        reviewCount: Int = 324,
        amenities: [String] = ["WiFi", "Pool", "Kitchen"]
    ) -> Stay {
        Stay(
            id: id, name: name, type: type,
            address: "Jl. Raya",
            city: city, country: country,
            latitude: -8.5069, longitude: 115.2625,
            pricePerNight: pricePerNight, currency: currency,
            rating: rating, reviewCount: reviewCount,
            amenities: amenities, imageURLs: []
        )
    }

    public static let sampleStays: [Stay] = [
        makeStay(),
        makeStay(id: "ST002", name: "Chiang Mai Co-Living", type: .guesthouse, city: "Chiang Mai", country: "Thailand", pricePerNight: 25, rating: 4.6, reviewCount: 189),
        makeStay(id: "ST003", name: "Lisbon Hostel", type: .hostel, city: "Lisbon", country: "Portugal", pricePerNight: 18, rating: 4.4, reviewCount: 567),
    ]
}
