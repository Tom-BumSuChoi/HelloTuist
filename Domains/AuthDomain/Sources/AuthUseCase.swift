import Foundation
import AuthDomainInterface
import NetworkCoreInterface
import StorageCoreInterface

public final class AuthUseCase: AuthUseCaseType {
    private let networkClient: NetworkClientType
    private let storageClient: StorageClientType

    private static let tokenKey = "auth_token"
    private static let userKey = "current_user"

    public init(networkClient: NetworkClientType, storageClient: StorageClientType) {
        self.networkClient = networkClient
        self.storageClient = storageClient
    }

    public func signIn(email: String, password: String) async throws -> User {
        let body = try JSONEncoder().encode(["email": email, "password": password])
        let endpoint = Endpoint(path: "/v1/auth/signin", method: .post, body: body)

        struct SignInResponse: Decodable {
            let user: User
            let token: AuthToken
        }

        let response: SignInResponse = try await networkClient.request(endpoint)
        try storageClient.save(response.token, forKey: Self.tokenKey)
        try storageClient.save(response.user, forKey: Self.userKey)
        return response.user
    }

    public func signUp(email: String, password: String, displayName: String) async throws -> User {
        let body = try JSONEncoder().encode([
            "email": email,
            "password": password,
            "displayName": displayName,
        ])
        let endpoint = Endpoint(path: "/v1/auth/signup", method: .post, body: body)

        struct SignUpResponse: Decodable {
            let user: User
            let token: AuthToken
        }

        let response: SignUpResponse = try await networkClient.request(endpoint)
        try storageClient.save(response.token, forKey: Self.tokenKey)
        try storageClient.save(response.user, forKey: Self.userKey)
        return response.user
    }

    public func signOut() async throws {
        let endpoint = Endpoint(path: "/v1/auth/signout", method: .post)
        let _: Data = try await networkClient.request(endpoint)
        storageClient.delete(forKey: Self.tokenKey)
        storageClient.delete(forKey: Self.userKey)
    }

    public func getCurrentUser() async throws -> User? {
        try storageClient.load(forKey: Self.userKey)
    }

    public func refreshToken() async throws -> AuthToken {
        guard let currentToken: AuthToken = try storageClient.load(forKey: Self.tokenKey) else {
            throw AuthError.notAuthenticated
        }
        let body = try JSONEncoder().encode(["refreshToken": currentToken.refreshToken])
        let endpoint = Endpoint(path: "/v1/auth/refresh", method: .post, body: body)
        let newToken: AuthToken = try await networkClient.request(endpoint)
        try storageClient.save(newToken, forKey: Self.tokenKey)
        return newToken
    }
}
