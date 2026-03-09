import Foundation
import ComposableArchitecture
import TravelDomainInterface

/// 항공권 검색 리듀서 - 문자열·비즈니스 로직 관리
@Reducer
public struct FlightSearchReducer {
    @ObservableState
    public struct State: Equatable {
        public var origin: String = ""
        public var destination: String = ""
        public var departureDate: Date = Date()
        public var cabinClass: CabinClass = .economy
        public var flights: IdentifiedArrayOf<Flight> = []
        public var isLoading: Bool = false
        public var errorMessage: String?
        public var hasSearched: Bool = false
        public var bookedFlightId: String?

        // MARK: - 화면 문자열 (리듀서에서 관리)
        public var navigationTitle: String { "항공권 검색" }
        public var originPlaceholder: String { "출발지 (예: ICN)" }
        public var destinationPlaceholder: String { "도착지 (예: BKK)" }
        public var departureLabel: String { "출발일" }
        public var cabinClassLabel: String { "좌석 등급" }
        public var searchButtonTitle: String { "항공권 검색" }
        public var loadingMessage: String { "항공편을 검색 중입니다..." }
        public var emptyResultMessage: String { "검색 결과가 없습니다" }
        public var validationErrorOriginDestination: String { "출발지와 도착지를 모두 입력해 주세요." }
        public func searchFailedMessage(_ error: String) -> String { "항공편 검색에 실패했습니다: \(error)" }

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case searchTapped
        case searchResponse(Result<[Flight], Error>)
        case bookFlightTapped(Flight)
    }

    @Dependency(\.flightSearchUseCase) var flightSearchUseCase

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.origin), .binding(\.destination), .binding(\.departureDate), .binding(\.cabinClass):
                return .none
            case .searchTapped:
                let origin = state.origin.trimmingCharacters(in: .whitespacesAndNewlines)
                let destination = state.destination.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !origin.isEmpty, !destination.isEmpty else {
                    state.errorMessage = state.validationErrorOriginDestination
                    return .none
                }
                state.isLoading = true
                state.errorMessage = nil
                return .run { [origin, destination, departureDate = state.departureDate, cabinClass = state.cabinClass] send in
                    await send(.searchResponse(Result {
                        try await flightSearchUseCase.searchFlights(
                            from: origin,
                            to: destination,
                            date: departureDate,
                            cabinClass: cabinClass
                        )
                    }))
                }
            case let .searchResponse(.success(flights)):
                state.flights = IdentifiedArray(uniqueElements: flights)
                state.hasSearched = true
                state.isLoading = false
                return .none
            case let .searchResponse(.failure(error)):
                state.errorMessage = state.searchFailedMessage(error.localizedDescription)
                state.flights = []
                state.isLoading = false
                return .none
            case let .bookFlightTapped(flight):
                state.bookedFlightId = flight.id
                return .none
            case .binding:
                return .none
            }
        }
    }
}

// MARK: - Dependency (App에서 withDependencies로 실제 UseCase 주입)
private enum FlightSearchUseCaseKey: DependencyKey {
    static let liveValue: FlightSearchUseCaseType = DefaultFlightSearchUseCase()
}

private struct DefaultFlightSearchUseCase: FlightSearchUseCaseType {
    func searchFlights(from: String, to: String, date: Date, cabinClass: CabinClass) async throws -> [Flight] { [] }
    func getFlightDetail(id: String) async throws -> Flight { fatalError("Override with real use case") }
}

extension DependencyValues {
    public var flightSearchUseCase: FlightSearchUseCaseType {
        get { self[FlightSearchUseCaseKey.self] }
        set { self[FlightSearchUseCaseKey.self] = newValue }
    }
}
