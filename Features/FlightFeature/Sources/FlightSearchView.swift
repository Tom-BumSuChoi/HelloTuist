import SwiftUI
import DesignSystem
import TravelDomainInterface

public struct FlightSearchView: View {
    @StateObject private var viewModel: FlightSearchViewModel

    public init(viewModel: FlightSearchViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    searchSection
                    statusSection
                    resultsList
                }
                .padding()
            }
            .background(NomadColors.surface)
            .navigationTitle("항공권 검색")
        }
    }

    private var searchSection: some View {
        NomadCard {
            VStack(spacing: 16) {
                NomadTextField("출발지 (예: ICN)", text: $viewModel.origin, icon: "airplane.departure")
                NomadTextField("도착지 (예: BKK)", text: $viewModel.destination, icon: "airplane.arrival")
                DatePicker("출발일", selection: $viewModel.departureDate, displayedComponents: .date)
                    .font(NomadFonts.body)
                Picker("좌석 등급", selection: $viewModel.cabinClass) {
                    ForEach(CabinClass.allCases, id: \.self) { cabin in
                        Text(cabin.rawValue.capitalized).tag(cabin)
                    }
                }
                .pickerStyle(.segmented)
                .font(NomadFonts.caption)
                NomadButton("항공권 검색", action: viewModel.search)
            }
        }
    }

    @ViewBuilder
    private var statusSection: some View {
        if viewModel.isLoading {
            ProgressView("항공편을 검색 중입니다...")
                .padding(.top, 32)
        } else if let error = viewModel.errorMessage {
            NomadCard {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(NomadColors.error)
                    Text(error)
                        .font(NomadFonts.body)
                        .foregroundColor(NomadColors.error)
                }
            }
        } else if viewModel.hasSearched && viewModel.flights.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "airplane.circle")
                    .font(.system(size: 40))
                    .foregroundColor(NomadColors.onSurfaceSecondary)
                Text("검색 결과가 없습니다")
                    .font(NomadFonts.body)
                    .foregroundColor(NomadColors.onSurfaceSecondary)
            }
            .padding(.top, 32)
        }
    }

    private var resultsList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.flights) { flight in
                NavigationLink(value: flight) {
                    FlightResultCard(flight: flight)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationDestination(for: Flight.self) { flight in
            FlightDetailView(flight: flight, onBook: { viewModel.bookFlight(flight) })
        }
    }
}

struct FlightResultCard: View {
    let flight: Flight

    var body: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(flight.airline)
                        .font(NomadFonts.headline)
                        .foregroundColor(NomadColors.onSurface)
                    Spacer()
                    Text(flight.flightNumber)
                        .font(NomadFonts.caption)
                        .foregroundColor(NomadColors.onSurfaceSecondary)
                }
                HStack {
                    Text(flight.departure.code)
                        .font(NomadFonts.title)
                    Image(systemName: "arrow.right")
                        .foregroundColor(NomadColors.accent)
                    Text(flight.arrival.code)
                        .font(NomadFonts.title)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(flight.price)")
                            .font(NomadFonts.headline)
                            .foregroundColor(NomadColors.accent)
                        Text(flight.currency)
                            .font(NomadFonts.small)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                }
                HStack {
                    Text(flight.cabinClass.rawValue.capitalized)
                        .font(NomadFonts.small)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(NomadColors.accent.opacity(0.1))
                        .cornerRadius(6)
                    Spacer()
                }
            }
        }
    }
}
