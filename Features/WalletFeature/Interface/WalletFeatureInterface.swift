import Foundation

public protocol WalletFeatureRouting {
    func showWallet()
    func showExchangeRate()
    func showSplitBill(tripId: String)
    func showTransactionDetail(transactionId: String)
}
