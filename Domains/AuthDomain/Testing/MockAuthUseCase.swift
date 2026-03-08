import Foundation
import AuthDomainInterface

public final class MockAuthUseCase: AuthUseCaseType {
    public var stubbedUser: User?
    public var stubbedToken: AuthToken?
    public var error: Error?

    public init() {}

    public func signIn(email: String, password: String) async throws -> User {
        if let error { throw error }
        return stubbedUser ?? User(id: "mock", email: email, displayName: "Mock User")
    }

    public func signUp(email: String, password: String, displayName: String) async throws -> User {
        if let error { throw error }
        return stubbedUser ?? User(id: "mock", email: email, displayName: displayName)
    }

    public func signOut() async throws {
        if let error { throw error }
        stubbedUser = nil
    }

    public func getCurrentUser() async throws -> User? {
        stubbedUser
    }

    public func refreshToken() async throws -> AuthToken {
        if let error { throw error }
        return stubbedToken ?? AuthToken(
            accessToken: "mock_access",
            refreshToken: "mock_refresh",
            expiresAt: Date().addingTimeInterval(3600)
        )
    }
}
