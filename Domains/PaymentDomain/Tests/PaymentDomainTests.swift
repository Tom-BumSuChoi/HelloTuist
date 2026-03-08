import Foundation
import XCTest
@testable import PaymentDomain
import PaymentDomainTesting
import PaymentDomainInterface

final class PaymentDomainTests: XCTestCase {
    func test_currency_model() {
        let currency = Currency(code: "KRW", name: "Korean Won", symbol: "₩")
        XCTAssertEqual(currency.id, "KRW")
        XCTAssertEqual(currency.symbol, "₩")
    }

    func test_splitBill_calculateBalances() {
        let useCase = MockSplitBillUseCase()
        let transactions = [
            Transaction(
                id: "T1",
                amount: 90,
                currency: "USD",
                description: "Dinner",
                category: .food,
                date: Date(),
                participants: [
                    Participant(id: "A", name: "Alice", share: 30, isPaid: true),
                    Participant(id: "B", name: "Bob", share: 30, isPaid: false),
                    Participant(id: "C", name: "Charlie", share: 30, isPaid: false),
                ]
            ),
        ]

        let balances = useCase.calculateBalances(for: transactions)
        XCTAssertEqual(balances["A"], 60)
        XCTAssertEqual(balances["B"], -30)
        XCTAssertEqual(balances["C"], -30)
    }

    func test_exchangeRate_model() {
        let rate = ExchangeRate(from: "USD", to: "KRW", rate: 1350.0, updatedAt: Date())
        XCTAssertEqual(rate.from, "USD")
        XCTAssertEqual(rate.rate, 1350.0)
    }
}
