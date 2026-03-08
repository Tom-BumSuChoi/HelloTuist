import Foundation
import PaymentDomainInterface

@MainActor
public final class WalletViewModel: ObservableObject {
    @Published public var amount: String = ""
    @Published public var fromCurrency: String = "KRW"
    @Published public var toCurrency: String = "USD"
    @Published public var convertedAmount: String?
    @Published public var convertError: String?
    @Published public var isConverting: Bool = false
    @Published public var transactions: [Transaction] = []
    @Published public var balances: [String: Decimal] = [:]
    @Published public var isLoadingTransactions: Bool = false
    @Published public var showAddTransaction: Bool = false

    private let exchangeRateUseCase: ExchangeRateUseCaseType
    private let splitBillUseCase: SplitBillUseCaseType
    public let tripId: String

    public init(
        tripId: String = "",
        exchangeRateUseCase: ExchangeRateUseCaseType,
        splitBillUseCase: SplitBillUseCaseType
    ) {
        self.tripId = tripId
        self.exchangeRateUseCase = exchangeRateUseCase
        self.splitBillUseCase = splitBillUseCase
    }

    public func convert() {
        guard let amountValue = Decimal(string: amount), amountValue > 0 else {
            convertError = "유효한 금액을 입력해 주세요."
            convertedAmount = nil
            return
        }

        isConverting = true
        convertError = nil

        Task {
            do {
                let result = try await exchangeRateUseCase.convert(
                    amount: amountValue, from: fromCurrency, to: toCurrency
                )
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 2
                convertedAmount = formatter.string(from: result as NSDecimalNumber) ?? "\(result)"
            } catch {
                convertError = "환율 변환 실패: \(error.localizedDescription)"
                convertedAmount = nil
            }
            isConverting = false
        }
    }

    public func loadTransactions() async {
        guard !tripId.isEmpty else { return }
        isLoadingTransactions = true
        do {
            transactions = try await splitBillUseCase.getTransactions(tripId: tripId)
            balances = splitBillUseCase.calculateBalances(for: transactions)
        } catch {
            transactions = []
            balances = [:]
        }
        isLoadingTransactions = false
    }

    public func addTransaction(_ transaction: Transaction) async {
        do {
            let created = try await splitBillUseCase.createTransaction(transaction)
            transactions.append(created)
            balances = splitBillUseCase.calculateBalances(for: transactions)
        } catch {
            convertError = "거래 추가 실패"
        }
    }
}
