import SwiftUI
import WalletFeature
import WalletFeatureTesting
import PaymentDomainInterface

@main
struct WalletExampleApp: App {
    var body: some Scene {
        WindowGroup {
            WalletView(
                viewModel: WalletViewModel(
                    exchangeRateUseCase: PreviewExchangeRateUseCase(),
                    splitBillUseCase: PreviewSplitBillUseCase()
                )
            )
        }
    }
}

private final class PreviewExchangeRateUseCase: ExchangeRateUseCaseType {
    func getExchangeRate(from: String, to: String) async throws -> ExchangeRate {
        ExchangeRate(from: from, to: to, rate: 0.00074, updatedAt: Date())
    }

    func convert(amount: Decimal, from: String, to: String) async throws -> Decimal {
        amount * Decimal(0.00074)
    }

    func getSupportedCurrencies() async throws -> [Currency] {
        [
            Currency(code: "KRW", name: "Korean Won", symbol: "₩"),
            Currency(code: "USD", name: "US Dollar", symbol: "$"),
            Currency(code: "THB", name: "Thai Baht", symbol: "฿"),
        ]
    }
}

private final class PreviewSplitBillUseCase: SplitBillUseCaseType {
    func createTransaction(_ transaction: Transaction) async throws -> Transaction { transaction }
    func getTransactions(tripId: String) async throws -> [Transaction] { [] }
    func calculateBalances(for transactions: [Transaction]) -> [String: Decimal] { [:] }
}
