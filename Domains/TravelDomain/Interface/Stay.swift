import Foundation

public struct Stay: Codable, Equatable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let type: StayType
    public let address: String
    public let city: String
    public let country: String
    public let latitude: Double
    public let longitude: Double
    public let pricePerNight: Decimal
    public let currency: String
    public let rating: Double
    public let reviewCount: Int
    public let amenities: [String]
    public let imageURLs: [String]

    public init(
        id: String,
        name: String,
        type: StayType,
        address: String,
        city: String,
        country: String,
        latitude: Double,
        longitude: Double,
        pricePerNight: Decimal,
        currency: String,
        rating: Double,
        reviewCount: Int,
        amenities: [String],
        imageURLs: [String]
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.address = address
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.pricePerNight = pricePerNight
        self.currency = currency
        self.rating = rating
        self.reviewCount = reviewCount
        self.amenities = amenities
        self.imageURLs = imageURLs
    }
}

public enum StayType: String, Codable, CaseIterable, Hashable {
    case hotel
    case hostel
    case airbnb
    case guesthouse
    case resort
}
