import Foundation

public struct Currency: Codable, Equatable, Identifiable {
    public var id: String { code }
    public let code: String
    public let name: String
    public let symbol: String

    public init(code: String, name: String, symbol: String) {
        self.code = code
        self.name = name
        self.symbol = symbol
    }
}

public struct ExchangeRate: Codable, Equatable {
    public let from: String
    public let to: String
    public let rate: Double
    public let updatedAt: Date

    public init(from: String, to: String, rate: Double, updatedAt: Date) {
        self.from = from
        self.to = to
        self.rate = rate
        self.updatedAt = updatedAt
    }
}
