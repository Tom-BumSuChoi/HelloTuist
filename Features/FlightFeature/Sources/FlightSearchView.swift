import SwiftUI
import ComposableArchitecture
import DesignSystem
import TravelDomainInterface

/// Dumb View - state 렌더링, action 전송만
/// 문자열은 FlightSearchReducer.State에서 관리
public struct FlightSearchView: View {
    @Bindable var store: StoreOf<FlightSearchReducer>

    public init(store: StoreOf<FlightSearchReducer>) {
        self.store = store
    }

    /// 기존 ViewModel 기반 호환용 (Example, 테스트 등)
    public init(flightSearchUseCase: FlightSearchUseCaseType) {
        self.store = Store(initialState: FlightSearchReducer.State()) {
            FlightSearchReducer()
        } withDependencies: {
            $0.flightSearchUseCase = flightSearchUseCase
        }
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NomadSpacing.lg) {
                    searchSection
                    statusSection
                    resultsList
                }
                .padding()
            }
            .background(NomadColors.surface)
            .navigationTitle(store.navigationTitle)
        }
    }

    private var searchSection: some View {
        NomadCard {
            VStack(spacing: NomadSpacing.md) {
                NomadTextField(store.originPlaceholder, text: $store.origin, icon: "airplane.departure")
                NomadTextField(store.destinationPlaceholder, text: $store.destination, icon: "airplane.arrival")
                DatePicker(store.departureLabel, selection: $store.departureDate, displayedComponents: .date)
                    .font(NomadFonts.body)
                Picker(store.cabinClassLabel, selection: $store.cabinClass) {
                    ForEach(CabinClass.allCases, id: \.self) { cabin in
                        Text(cabin.rawValue.capitalized).tag(cabin)
                    }
                }
                .pickerStyle(.segmented)
                .font(NomadFonts.caption)
                NomadButton(store.searchButtonTitle) {
                    store.send(.searchTapped)
                }
            }
        }
    }

    @ViewBuilder
    private var statusSection: some View {
        if store.isLoading {
            ProgressView(store.loadingMessage)
                .padding(.top, NomadSpacing.xxl)
        } else if let error = store.errorMessage {
            NomadCard {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(NomadColors.error)
                    Text(error)
                        .font(NomadFonts.body)
                        .foregroundColor(NomadColors.error)
                }
            }
        } else if store.hasSearched && store.flights.isEmpty {
            VStack(spacing: NomadSpacing.xs) {
                Image(systemName: "airplane.circle")
                    .font(.system(size: 40))
                    .foregroundColor(NomadColors.onSurfaceSecondary)
                Text(store.emptyResultMessage)
                    .font(NomadFonts.body)
                    .foregroundColor(NomadColors.onSurfaceSecondary)
            }
            .padding(.top, NomadSpacing.xxl)
        }
    }

    private var resultsList: some View {
        LazyVStack(spacing: NomadSpacing.sm) {
            ForEach(store.flights) { flight in
                NavigationLink(value: flight) {
                    FlightResultCard(flight: flight)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationDestination(for: Flight.self) { flight in
            FlightDetailView(flight: flight, onBook: { store.send(.bookFlightTapped(flight)) })
        }
    }
}

struct FlightResultCard: View {
    let flight: Flight

    var body: some View {
        NomadCard {
            VStack(alignment: .leading, spacing: NomadSpacing.xs) {
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
                        Text(verbatim: "\(flight.price)")
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
                        .padding(.horizontal, NomadSpacing.xs)
                        .padding(.vertical, NomadSpacing.xxs)
                        .background(NomadColors.accent.opacity(0.1))
                        .cornerRadius(NomadRadius.sm)
                    Spacer()
                }
            }
        }
    }
}
