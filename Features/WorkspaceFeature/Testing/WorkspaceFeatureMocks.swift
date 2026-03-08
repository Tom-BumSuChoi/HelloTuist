import Foundation
import WorkspaceFeatureInterface

public final class MockWorkspaceFeatureRouting: WorkspaceFeatureRouting {
    public var showWorkspaceSearchCallCount = 0
    public var showWorkspaceDetailIds: [String] = []
    public var showDayPassBookingIds: [String] = []

    public init() {}

    public func showWorkspaceSearch() { showWorkspaceSearchCallCount += 1 }
    public func showWorkspaceDetail(workspaceId: String) { showWorkspaceDetailIds.append(workspaceId) }
    public func showDayPassBooking(workspaceId: String) { showDayPassBookingIds.append(workspaceId) }
}

public enum WorkspaceFixtures {
    public static func makeSpace(
        id: String = "WS001",
        name: String = "Hubba Thailand",
        city: String = "Bangkok",
        country: String = "Thailand",
        wifiSpeed: Int = 200,
        dailyPrice: Decimal = 350,
        currency: String = "THB",
        rating: Double = 4.7,
        amenities: [String] = ["WiFi", "Meeting Room", "Coffee", "Standing Desk", "24/7"]
    ) -> CoworkingSpace {
        CoworkingSpace(
            id: id, name: name,
            address: "Central Business District",
            city: city, country: country,
            latitude: 13.7231, longitude: 100.5831,
            wifiSpeed: wifiSpeed, dailyPrice: dailyPrice, currency: currency,
            rating: rating, amenities: amenities,
            openingHours: "24/7", imageURLs: []
        )
    }

    public static let sampleSpaces: [CoworkingSpace] = [
        makeSpace(),
        makeSpace(id: "WS002", name: "Dojo Bali", city: "Canggu", country: "Indonesia", wifiSpeed: 100, dailyPrice: 150000, currency: "IDR", rating: 4.5, amenities: ["WiFi", "Pool", "Cafe", "Events"]),
        makeSpace(id: "WS003", name: "Selina CoWork", city: "Lisbon", country: "Portugal", wifiSpeed: 150, dailyPrice: 25, currency: "EUR", rating: 4.3, amenities: ["WiFi", "Rooftop", "Bar"]),
    ]
}
