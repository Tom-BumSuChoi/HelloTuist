import SwiftUI
import DesignSystem
import PaymentDomainInterface

public struct WalletView: View {
    @StateObject private var viewModel: WalletViewModel

    public init(viewModel: WalletViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    exchangeRateCard
                    splitBillSection
                }
                .padding()
            }
            .background(NomadColors.surface)
            .navigationTitle("여행 지갑")
            .task { await viewModel.loadTransactions() }
        }
    }

    private var exchangeRateCard: some View {
        NomadCard {
            VStack(spacing: 16) {
                HStack {
                    Text("환율 계산")
                        .font(NomadFonts.headline)
                    Spacer()
                }
                HStack(spacing: 12) {
                    NomadTextField("금액", text: $viewModel.amount, icon: "wonsign.circle")
                    VStack(spacing: 4) {
                        Text(viewModel.fromCurrency)
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                        Image(systemName: "arrow.down")
                            .font(NomadFonts.small)
                            .foregroundColor(NomadColors.accent)
                        Text(viewModel.toCurrency)
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                }
                if viewModel.isConverting {
                    ProgressView()
                } else if let converted = viewModel.convertedAmount {
                    HStack {
                        Text(converted)
                            .font(NomadFonts.title)
                            .foregroundColor(NomadColors.accent)
                        Text(viewModel.toCurrency)
                            .font(NomadFonts.body)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                        Spacer()
                    }
                }
                if let error = viewModel.convertError {
                    Text(error)
                        .font(NomadFonts.caption)
                        .foregroundColor(NomadColors.error)
                }
                NomadButton("환전 계산", style: .secondary, action: viewModel.convert)
            }
        }
    }

    private var splitBillSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("경비 정산")
                    .font(NomadFonts.headline)
                    .foregroundColor(NomadColors.onSurface)
                Spacer()
                Button(action: { viewModel.showAddTransaction = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(NomadColors.accent)
                }
            }

            if viewModel.isLoadingTransactions {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if viewModel.transactions.isEmpty {
                NomadCard {
                    VStack(spacing: 8) {
                        Image(systemName: "creditcard")
                            .font(.system(size: 32))
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                        Text("아직 거래 내역이 없습니다")
                            .font(NomadFonts.body)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            } else {
                balanceSummary
                ForEach(viewModel.transactions) { transaction in
                    TransactionCard(transaction: transaction)
                }
            }
        }
    }

    @ViewBuilder
    private var balanceSummary: some View {
        if !viewModel.balances.isEmpty {
            NomadCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("정산 현황")
                        .font(NomadFonts.caption)
                        .foregroundColor(NomadColors.onSurfaceSecondary)
                    ForEach(Array(viewModel.balances.sorted(by: { $0.key < $1.key })), id: \.key) { name, balance in
                        HStack {
                            Text(name)
                                .font(NomadFonts.body)
                            Spacer()
                            Text("\(balance > 0 ? "+" : "")\(balance)")
                                .font(NomadFonts.headline)
                                .foregroundColor(balance >= 0 ? NomadColors.success : NomadColors.error)
                        }
                    }
                }
            }
        }
    }
}

struct TransactionCard: View {
    let transaction: Transaction

    var body: some View {
        NomadCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.description)
                        .font(NomadFonts.body)
                        .foregroundColor(NomadColors.onSurface)
                    HStack(spacing: 8) {
                        Text(transaction.category.rawValue.capitalized)
                            .font(NomadFonts.small)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(NomadColors.accent.opacity(0.1))
                            .cornerRadius(4)
                        Text("\(transaction.participants.count)명")
                            .font(NomadFonts.caption)
                            .foregroundColor(NomadColors.onSurfaceSecondary)
                    }
                }
                Spacer()
                Text("\(transaction.currency) \(transaction.amount)")
                    .font(NomadFonts.headline)
                    .foregroundColor(NomadColors.onSurface)
            }
        }
    }
}
