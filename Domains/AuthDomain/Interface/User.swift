import Foundation

public struct User: Codable, Equatable, Identifiable {
    public let id: String
    public let email: String
    public let displayName: String
    public let profileImageURL: String?
    public let nationality: String?
    public let preferredCurrency: String

    public init(
        id: String,
        email: String,
        displayName: String,
        profileImageURL: String? = nil,
        nationality: String? = nil,
        preferredCurrency: String = "USD"
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.profileImageURL = profileImageURL
        self.nationality = nationality
        self.preferredCurrency = preferredCurrency
    }
}

public struct AuthToken: Codable, Equatable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date

    public init(accessToken: String, refreshToken: String, expiresAt: Date) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }

    public var isExpired: Bool {
        Date() >= expiresAt
    }
}
