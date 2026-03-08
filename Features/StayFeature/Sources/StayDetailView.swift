import SwiftUI
import DesignSystem
import TravelDomainInterface

struct StayDetailView: View {
    let stay: Stay
    let nights: Int
    let onBook: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                amenitiesSection
                pricingSection
                NomadButton("예약하기") {
                    onBook()
                }
            }
            .padding()
        }
        .background(NomadColors.surface)
        .navigationTitle(stay.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(stay.type.rawValue.capitalized)
                        .font(NomadFonts.small)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(NomadColors.accent.opacity(0.1))
                        .cornerRadius(6)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(NomadColors.highlight)
                        Text("\(stay.rating, specifier: "%.1f") (\(stay.reviewCount))")
                            .font(NomadFonts.caption)
                    }
                }
                Text(stay.name)
                    .font(NomadFonts.title)
                    .foregroundColor(NomadColors.onSurface)
                Label("\(stay.address), \(stay.city), \(stay.country)", systemImage: "mappin")
                    .font(NomadFonts.body)
                    .foregroundColor(NomadColors.onSurfaceSecondary)
            }
        }
    }

    private var amenitiesSection: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("편의 시설")
                    .font(NomadFonts.headline)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                    ForEach(stay.amenities, id: \.self) { amenity in
                        Text(amenity)
                            .font(NomadFonts.small)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(NomadColors.surface)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private var pricingSection: some View {
        NomadCard {
            VStack(spacing: 8) {
                HStack {
                    Text("\(stay.currency) \(stay.pricePerNight) × \(nights)박")
                        .font(NomadFonts.body)
                    Spacer()
                    let total = stay.pricePerNight * Decimal(nights)
                    Text("\(stay.currency) \(total)")
                        .font(NomadFonts.title)
                        .foregroundColor(NomadColors.accent)
                }
            }
        }
    }
}
