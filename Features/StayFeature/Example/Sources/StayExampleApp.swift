import SwiftUI
import StayFeature
import StayFeatureTesting
import TravelDomainInterface

@main
struct StayExampleApp: App {
    var body: some Scene {
        WindowGroup {
            StaySearchView(
                viewModel: StaySearchViewModel(
                    staySearchUseCase: PreviewStaySearchUseCase()
                )
            )
        }
    }
}

private final class PreviewStaySearchUseCase: StaySearchUseCaseType {
    func searchStays(city: String, checkIn: Date, checkOut: Date, guests: Int) async throws -> [Stay] {
        [
            Stay(
                id: "ST001", name: "Ubud Nomad Villa", type: .airbnb,
                address: "Jl. Raya Ubud", city: "Ubud", country: "Indonesia",
                latitude: -8.5069, longitude: 115.2625,
                pricePerNight: 45, currency: "USD",
                rating: 4.8, reviewCount: 324,
                amenities: ["WiFi", "Pool", "Kitchen"], imageURLs: []
            ),
            Stay(
                id: "ST002", name: "Chiang Mai Co-Living", type: .guesthouse,
                address: "Nimmanhaemin Rd", city: "Chiang Mai", country: "Thailand",
                latitude: 18.7953, longitude: 98.9683,
                pricePerNight: 25, currency: "USD",
                rating: 4.6, reviewCount: 189,
                amenities: ["WiFi", "Coworking", "Laundry"], imageURLs: []
            ),
        ]
    }

    func getStayDetail(id: String) async throws -> Stay {
        Stay(
            id: id, name: "Ubud Nomad Villa", type: .airbnb,
            address: "Jl. Raya Ubud", city: "Ubud", country: "Indonesia",
            latitude: -8.5069, longitude: 115.2625,
            pricePerNight: 45, currency: "USD",
            rating: 4.8, reviewCount: 324,
            amenities: ["WiFi", "Pool", "Kitchen"], imageURLs: []
        )
    }
}
