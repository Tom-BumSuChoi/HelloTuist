import SwiftUI
import FlightFeature
import StayFeature
import WalletFeature
import CommunityFeature
import WorkspaceFeature
import TravelDomainInterface
import PaymentDomainInterface
import NetworkCoreInterface

@main
struct NomadSpaceApp: App {
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            MainTabView(dependencies: dependencies)
        }
    }
}

struct AppDependencies {
    let networkClient: NetworkClientType
    let flightSearchUseCase: FlightSearchUseCaseType
    let staySearchUseCase: StaySearchUseCaseType
    let exchangeRateUseCase: ExchangeRateUseCaseType
    let splitBillUseCase: SplitBillUseCaseType

    init(
        networkClient: NetworkClientType? = nil,
        flightSearchUseCase: FlightSearchUseCaseType? = nil,
        staySearchUseCase: StaySearchUseCaseType? = nil,
        exchangeRateUseCase: ExchangeRateUseCaseType? = nil,
        splitBillUseCase: SplitBillUseCaseType? = nil
    ) {
        self.networkClient = networkClient ?? StubNetworkClient()
        self.flightSearchUseCase = flightSearchUseCase ?? StubFlightSearchUseCase()
        self.staySearchUseCase = staySearchUseCase ?? StubStaySearchUseCase()
        self.exchangeRateUseCase = exchangeRateUseCase ?? StubExchangeRateUseCase()
        self.splitBillUseCase = splitBillUseCase ?? StubSplitBillUseCase()
    }
}

private struct StubNetworkClient: NetworkClientType {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T { throw NetworkError.noData }
    func request(_ endpoint: Endpoint) async throws -> Data { throw NetworkError.noData }
}

private struct StubFlightSearchUseCase: FlightSearchUseCaseType {
    func searchFlights(from: String, to: String, date: Date, cabinClass: CabinClass) async throws -> [Flight] { [] }
    func getFlightDetail(id: String) async throws -> Flight { throw NetworkError.noData }
}

private struct StubStaySearchUseCase: StaySearchUseCaseType {
    func searchStays(city: String, checkIn: Date, checkOut: Date, guests: Int) async throws -> [Stay] { [] }
    func getStayDetail(id: String) async throws -> Stay { throw NetworkError.noData }
}

private struct StubExchangeRateUseCase: ExchangeRateUseCaseType {
    func getExchangeRate(from: String, to: String) async throws -> ExchangeRate {
        ExchangeRate(from: from, to: to, rate: 1.0, updatedAt: Date())
    }
    func convert(amount: Decimal, from: String, to: String) async throws -> Decimal { amount }
    func getSupportedCurrencies() async throws -> [Currency] { [] }
}

private struct StubSplitBillUseCase: SplitBillUseCaseType {
    func createTransaction(_ transaction: Transaction) async throws -> Transaction { transaction }
    func getTransactions(tripId: String) async throws -> [Transaction] { [] }
    func calculateBalances(for transactions: [Transaction]) -> [String: Decimal] { [:] }
}
