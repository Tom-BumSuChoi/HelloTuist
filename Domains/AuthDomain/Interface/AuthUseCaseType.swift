import Foundation

public protocol AuthUseCaseType {
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, displayName: String) async throws -> User
    func signOut() async throws
    func getCurrentUser() async throws -> User?
    func refreshToken() async throws -> AuthToken
}

public enum AuthError: Error, Equatable {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case tokenExpired
    case notAuthenticated
    case networkError
}
