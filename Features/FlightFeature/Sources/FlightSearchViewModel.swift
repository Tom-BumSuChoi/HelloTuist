import Foundation
import TravelDomainInterface

@MainActor
public final class FlightSearchViewModel: ObservableObject {
    @Published public var origin: String = ""
    @Published public var destination: String = ""
    @Published public var departureDate: Date = Date()
    @Published public var cabinClass: CabinClass = .economy
    @Published public var flights: [Flight] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public private(set) var hasSearched: Bool = false
    @Published public private(set) var bookedFlightId: String?

    private let flightSearchUseCase: FlightSearchUseCaseType

    public init(flightSearchUseCase: FlightSearchUseCaseType) {
        self.flightSearchUseCase = flightSearchUseCase
    }

    public func search() {
        let trimmedOrigin = origin.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDestination = destination.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedOrigin.isEmpty, !trimmedDestination.isEmpty else {
            errorMessage = "출발지와 도착지를 모두 입력해 주세요."
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                flights = try await flightSearchUseCase.searchFlights(
                    from: trimmedOrigin,
                    to: trimmedDestination,
                    date: departureDate,
                    cabinClass: cabinClass
                )
                hasSearched = true
            } catch {
                errorMessage = "항공편 검색에 실패했습니다: \(error.localizedDescription)"
                flights = []
            }
            isLoading = false
        }
    }

    public func bookFlight(_ flight: Flight) {
        bookedFlightId = flight.id
    }
}
