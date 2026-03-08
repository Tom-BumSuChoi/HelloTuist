import Foundation
import XCTest
@testable import WalletFeature
import WalletFeatureTesting
import PaymentDomainInterface

// MARK: - Test Doubles

private final class SpyExchangeRateUseCase: ExchangeRateUseCaseType {
    var convertCallCount = 0
    var lastConvertFrom: String?
    var lastConvertTo: String?
    var stubbedConvertResult: Decimal = 0
    var stubbedError: Error?

    func getExchangeRate(from: String, to: String) async throws -> ExchangeRate {
        ExchangeRate(from: from, to: to, rate: 0.00074, updatedAt: Date())
    }

    func convert(amount: Decimal, from: String, to: String) async throws -> Decimal {
        convertCallCount += 1
        lastConvertFrom = from
        lastConvertTo = to
        if let error = stubbedError { throw error }
        return stubbedConvertResult
    }

    func getSupportedCurrencies() async throws -> [Currency] { [] }
}

private final class SpySplitBillUseCase: SplitBillUseCaseType {
    var getTransactionsCallCount = 0
    var createTransactionCallCount = 0
    var lastTripId: String?
    var stubbedTransactions: [Transaction] = []
    var stubbedError: Error?

    func createTransaction(_ transaction: Transaction) async throws -> Transaction {
        createTransactionCallCount += 1
        if let error = stubbedError { throw error }
        return transaction
    }

    func getTransactions(tripId: String) async throws -> [Transaction] {
        getTransactionsCallCount += 1
        lastTripId = tripId
        if let error = stubbedError { throw error }
        return stubbedTransactions
    }

    func calculateBalances(for transactions: [Transaction]) -> [String: Decimal] {
        var balances: [String: Decimal] = [:]
        for transaction in transactions {
            let splitAmount = transaction.amount / Decimal(max(transaction.participants.count, 1))
            for participant in transaction.participants {
                balances[participant.name, default: 0] += participant.isPaid
                    ? (transaction.amount - splitAmount)
                    : -splitAmount
            }
        }
        return balances
    }
}

// MARK: - ViewModel Tests

@MainActor
final class WalletViewModelTests: XCTestCase {
    private var exchangeUseCase: SpyExchangeRateUseCase!
    private var splitBillUseCase: SpySplitBillUseCase!
    private var sut: WalletViewModel!

    override func setUp() {
        super.setUp()
        exchangeUseCase = SpyExchangeRateUseCase()
        splitBillUseCase = SpySplitBillUseCase()
        sut = WalletViewModel(
            tripId: "TRIP001",
            exchangeRateUseCase: exchangeUseCase,
            splitBillUseCase: splitBillUseCase
        )
    }

    func test_initialState() {
        XCTAssertEqual(sut.amount, "")
        XCTAssertEqual(sut.fromCurrency, "KRW")
        XCTAssertEqual(sut.toCurrency, "USD")
        XCTAssertNil(sut.convertedAmount)
        XCTAssertTrue(sut.transactions.isEmpty)
    }

    func test_convert_withInvalidAmount_showsError() {
        sut.amount = "abc"
        sut.convert()

        XCTAssertNotNil(sut.convertError)
        XCTAssertNil(sut.convertedAmount)
        XCTAssertEqual(exchangeUseCase.convertCallCount, 0)
    }

    func test_convert_withZeroAmount_showsError() {
        sut.amount = "0"
        sut.convert()

        XCTAssertNotNil(sut.convertError)
        XCTAssertEqual(exchangeUseCase.convertCallCount, 0)
    }

    func test_convert_success() async throws {
        exchangeUseCase.stubbedConvertResult = 74.0
        sut.amount = "100000"

        sut.convert()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.convertedAmount)
        XCTAssertNil(sut.convertError)
        XCTAssertFalse(sut.isConverting)
        XCTAssertEqual(exchangeUseCase.lastConvertFrom, "KRW")
        XCTAssertEqual(exchangeUseCase.lastConvertTo, "USD")
    }

    func test_convert_failure_showsError() async throws {
        exchangeUseCase.stubbedError = NSError(domain: "test", code: -1)
        sut.amount = "100000"

        sut.convert()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.convertError)
        XCTAssertNil(sut.convertedAmount)
    }

    func test_loadTransactions_success() async {
        splitBillUseCase.stubbedTransactions = [WalletFixtures.makeTransaction()]
        await sut.loadTransactions()

        XCTAssertEqual(sut.transactions.count, 1)
        XCTAssertEqual(splitBillUseCase.lastTripId, "TRIP001")
        XCTAssertFalse(sut.balances.isEmpty)
    }

    func test_loadTransactions_emptyTripId_skips() async {
        let emptyTrip = WalletViewModel(
            tripId: "",
            exchangeRateUseCase: exchangeUseCase,
            splitBillUseCase: splitBillUseCase
        )
        await emptyTrip.loadTransactions()

        XCTAssertEqual(splitBillUseCase.getTransactionsCallCount, 0)
    }

    func test_balanceCalculation() async {
        splitBillUseCase.stubbedTransactions = [WalletFixtures.makeTransaction()]
        await sut.loadTransactions()

        XCTAssertEqual(sut.balances["Alice"], 60)
        XCTAssertEqual(sut.balances["Bob"], -30)
        XCTAssertEqual(sut.balances["Charlie"], -30)
    }
}
