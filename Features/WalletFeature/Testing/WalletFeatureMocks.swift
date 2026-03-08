import Foundation
import WalletFeatureInterface
import PaymentDomainInterface

public final class MockWalletFeatureRouting: WalletFeatureRouting {
    public var showWalletCallCount = 0
    public var showExchangeRateCallCount = 0
    public var showSplitBillTripIds: [String] = []
    public var showTransactionDetailIds: [String] = []

    public init() {}

    public func showWallet() { showWalletCallCount += 1 }
    public func showExchangeRate() { showExchangeRateCallCount += 1 }
    public func showSplitBill(tripId: String) { showSplitBillTripIds.append(tripId) }
    public func showTransactionDetail(transactionId: String) { showTransactionDetailIds.append(transactionId) }
}

public enum WalletFixtures {
    public static func makeTransaction(
        id: String = "T1",
        amount: Decimal = 90,
        currency: String = "USD",
        description: String = "저녁 식사",
        category: TransactionCategory = .food,
        participants: [Participant]? = nil
    ) -> Transaction {
        Transaction(
            id: id,
            amount: amount,
            currency: currency,
            description: description,
            category: category,
            date: Date(),
            participants: participants ?? [
                Participant(id: "A", name: "Alice", share: 30, isPaid: true),
                Participant(id: "B", name: "Bob", share: 30, isPaid: false),
                Participant(id: "C", name: "Charlie", share: 30, isPaid: false),
            ]
        )
    }

    public static let sampleTransactions: [Transaction] = [
        makeTransaction(),
        makeTransaction(id: "T2", amount: 120, description: "택시", category: .transport),
        makeTransaction(id: "T3", amount: 200, description: "입장권", category: .activity),
    ]
}
