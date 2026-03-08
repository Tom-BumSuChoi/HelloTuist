import Foundation

public struct Transaction: Codable, Equatable, Identifiable {
    public let id: String
    public let amount: Decimal
    public let currency: String
    public let description: String
    public let category: TransactionCategory
    public let date: Date
    public let participants: [Participant]

    public init(
        id: String,
        amount: Decimal,
        currency: String,
        description: String,
        category: TransactionCategory,
        date: Date,
        participants: [Participant]
    ) {
        self.id = id
        self.amount = amount
        self.currency = currency
        self.description = description
        self.category = category
        self.date = date
        self.participants = participants
    }
}

public struct Participant: Codable, Equatable, Identifiable {
    public let id: String
    public let name: String
    public let share: Decimal
    public let isPaid: Bool

    public init(id: String, name: String, share: Decimal, isPaid: Bool) {
        self.id = id
        self.name = name
        self.share = share
        self.isPaid = isPaid
    }
}

public enum TransactionCategory: String, Codable, CaseIterable {
    case flight
    case accommodation
    case food
    case transport
    case activity
    case shopping
    case other
}
