import SwiftUI
import DesignSystem
import WorkspaceFeatureInterface

struct WorkspaceDetailView: View {
    let space: CoworkingSpace
    let onBookDayPass: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                infoSection
                amenitiesSection
                NomadButton("일일권 예약 (\(space.currency) \(space.dailyPrice))") {
                    onBookDayPass()
                }
            }
            .padding()
        }
        .background(NomadColors.surface)
        .navigationTitle(space.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(space.name)
                    .font(NomadFonts.title)
                    .foregroundColor(NomadColors.onSurface)
                Label("\(space.address), \(space.city), \(space.country)", systemImage: "mappin")
                    .font(NomadFonts.body)
                    .foregroundColor(NomadColors.onSurfaceSecondary)
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(NomadColors.highlight)
                        Text("\(space.rating, specifier: "%.1f")")
                            .font(NomadFonts.headline)
                    }
                    Spacer()
                    Text(space.openingHours)
                        .font(NomadFonts.body)
                        .foregroundColor(NomadColors.onSurfaceSecondary)
                }
            }
        }
    }

    private var infoSection: some View {
        NomadCard {
            VStack(spacing: 12) {
                infoRow(icon: "wifi", label: "WiFi 속도", value: "\(space.wifiSpeed) Mbps", color: NomadColors.success)
                infoRow(icon: "banknote", label: "일일 가격", value: "\(space.currency) \(space.dailyPrice)", color: NomadColors.accent)
                infoRow(icon: "clock", label: "영업 시간", value: space.openingHours, color: NomadColors.onSurfaceSecondary)
            }
        }
    }

    private func infoRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(label)
                .font(NomadFonts.body)
                .foregroundColor(NomadColors.onSurfaceSecondary)
            Spacer()
            Text(value)
                .font(NomadFonts.headline)
                .foregroundColor(NomadColors.onSurface)
        }
    }

    private var amenitiesSection: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("편의 시설")
                    .font(NomadFonts.headline)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                    ForEach(space.amenities, id: \.self) { amenity in
                        Text(amenity)
                            .font(NomadFonts.small)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(NomadColors.surface)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
