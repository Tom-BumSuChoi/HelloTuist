import Foundation
import PaymentDomainInterface
import NetworkCoreInterface

public final class ExchangeRateUseCase: ExchangeRateUseCaseType {
    private let networkClient: NetworkClientType

    public init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    public func getExchangeRate(from: String, to: String) async throws -> ExchangeRate {
        let endpoint = Endpoint(
            path: "/v1/exchange-rates",
            queryItems: [
                URLQueryItem(name: "from", value: from),
                URLQueryItem(name: "to", value: to),
            ]
        )
        return try await networkClient.request(endpoint)
    }

    public func convert(amount: Decimal, from: String, to: String) async throws -> Decimal {
        let rate = try await getExchangeRate(from: from, to: to)
        return amount * Decimal(rate.rate)
    }

    public func getSupportedCurrencies() async throws -> [Currency] {
        let endpoint = Endpoint(path: "/v1/currencies")
        return try await networkClient.request(endpoint)
    }
}

public final class SplitBillUseCase: SplitBillUseCaseType {
    private let networkClient: NetworkClientType

    public init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    public func createTransaction(_ transaction: Transaction) async throws -> Transaction {
        let body = try JSONEncoder().encode(transaction)
        let endpoint = Endpoint(path: "/v1/transactions", method: .post, body: body)
        return try await networkClient.request(endpoint)
    }

    public func getTransactions(tripId: String) async throws -> [Transaction] {
        let endpoint = Endpoint(
            path: "/v1/trips/\(tripId)/transactions"
        )
        return try await networkClient.request(endpoint)
    }

    public func calculateBalances(for transactions: [Transaction]) -> [String: Decimal] {
        var balances: [String: Decimal] = [:]
        for transaction in transactions {
            let splitAmount = transaction.amount / Decimal(max(transaction.participants.count, 1))
            for participant in transaction.participants {
                balances[participant.id, default: 0] += participant.isPaid
                    ? (transaction.amount - splitAmount)
                    : -splitAmount
            }
        }
        return balances
    }
}
