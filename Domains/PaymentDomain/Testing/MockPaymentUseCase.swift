import Foundation
import PaymentDomainInterface

public final class MockExchangeRateUseCase: ExchangeRateUseCaseType {
    public var stubbedRate: ExchangeRate?
    public var stubbedCurrencies: [Currency] = []
    public var error: Error?

    public init() {}

    public func getExchangeRate(from: String, to: String) async throws -> ExchangeRate {
        if let error { throw error }
        return stubbedRate ?? ExchangeRate(from: from, to: to, rate: 1.0, updatedAt: Date())
    }

    public func convert(amount: Decimal, from: String, to: String) async throws -> Decimal {
        if let error { throw error }
        let rate = stubbedRate?.rate ?? 1.0
        return amount * Decimal(rate)
    }

    public func getSupportedCurrencies() async throws -> [Currency] {
        if let error { throw error }
        return stubbedCurrencies
    }
}

public final class MockSplitBillUseCase: SplitBillUseCaseType {
    public var stubbedTransactions: [Transaction] = []
    public var error: Error?

    public init() {}

    public func createTransaction(_ transaction: Transaction) async throws -> Transaction {
        if let error { throw error }
        return transaction
    }

    public func getTransactions(tripId: String) async throws -> [Transaction] {
        if let error { throw error }
        return stubbedTransactions
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
