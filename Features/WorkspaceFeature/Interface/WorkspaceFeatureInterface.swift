import Foundation

public struct CoworkingSpace: Codable, Equatable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let address: String
    public let city: String
    public let country: String
    public let latitude: Double
    public let longitude: Double
    public let wifiSpeed: Int
    public let dailyPrice: Decimal
    public let currency: String
    public let rating: Double
    public let amenities: [String]
    public let openingHours: String
    public let imageURLs: [String]

    public init(
        id: String, name: String, address: String, city: String, country: String,
        latitude: Double, longitude: Double, wifiSpeed: Int,
        dailyPrice: Decimal, currency: String, rating: Double,
        amenities: [String], openingHours: String, imageURLs: [String]
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.wifiSpeed = wifiSpeed
        self.dailyPrice = dailyPrice
        self.currency = currency
        self.rating = rating
        self.amenities = amenities
        self.openingHours = openingHours
        self.imageURLs = imageURLs
    }
}

public protocol WorkspaceFeatureRouting {
    func showWorkspaceSearch()
    func showWorkspaceDetail(workspaceId: String)
    func showDayPassBooking(workspaceId: String)
}
