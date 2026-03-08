import Foundation

public protocol ExchangeRateUseCaseType {
    func getExchangeRate(from: String, to: String) async throws -> ExchangeRate
    func convert(amount: Decimal, from: String, to: String) async throws -> Decimal
    func getSupportedCurrencies() async throws -> [Currency]
}

public protocol SplitBillUseCaseType {
    func createTransaction(_ transaction: Transaction) async throws -> Transaction
    func getTransactions(tripId: String) async throws -> [Transaction]
    func calculateBalances(for transactions: [Transaction]) -> [String: Decimal]
}
