import SwiftUI
import DesignSystem
import TravelDomainInterface

struct FlightDetailView: View {
    let flight: Flight
    let onBook: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                routeSection
                detailsSection
                NomadButton("예약하기") {
                    onBook()
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .background(NomadColors.surface)
        .navigationTitle(flight.flightNumber)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var routeSection: some View {
        NomadCard {
            VStack(spacing: 16) {
                HStack {
                    VStack {
                        Text(flight.departure.code)
                            .font(NomadFonts.largeTitle)
                            .foregroundColor(NomadColors.onSurface)
                        Text(flight.departure.city)
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Image(systemName: "airplane")
                            .foregroundColor(NomadColors.accent)
                        Text(flight.airline)
                            .font(NomadFonts.small)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                    Spacer()
                    VStack {
                        Text(flight.arrival.code)
                            .font(NomadFonts.largeTitle)
                            .foregroundColor(NomadColors.onSurface)
                        Text(flight.arrival.city)
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                }
            }
        }
    }

    private var detailsSection: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 12) {
                detailRow(icon: "ticket", label: "편명", value: flight.flightNumber)
                detailRow(icon: "chair.lounge", label: "좌석 등급", value: flight.cabinClass.rawValue.capitalized)
                detailRow(icon: "banknote", label: "가격", value: "\(flight.currency) \(flight.price)")
            }
        }
    }

    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(NomadColors.accent)
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
}
