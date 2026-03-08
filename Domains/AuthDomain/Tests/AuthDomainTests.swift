import Foundation
import XCTest
@testable import AuthDomain
import AuthDomainTesting
import AuthDomainInterface

final class AuthDomainTests: XCTestCase {
    func test_user_model() {
        let user = User(
            id: "U001",
            email: "nomad@example.com",
            displayName: "Digital Nomad",
            nationality: "KR",
            preferredCurrency: "KRW"
        )
        XCTAssertEqual(user.id, "U001")
        XCTAssertEqual(user.preferredCurrency, "KRW")
    }

    func test_authToken_expiry() {
        let expiredToken = AuthToken(
            accessToken: "expired",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(-3600)
        )
        XCTAssertTrue(expiredToken.isExpired)

        let validToken = AuthToken(
            accessToken: "valid",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(3600)
        )
        XCTAssertFalse(validToken.isExpired)
    }

    func test_mockAuthUseCase_signIn() async throws {
        let mock = MockAuthUseCase()
        let user = try await mock.signIn(email: "test@test.com", password: "pass")
        XCTAssertEqual(user.email, "test@test.com")
    }

    func test_mockAuthUseCase_signInError() async {
        let mock = MockAuthUseCase()
        mock.error = AuthError.invalidCredentials

        do {
            _ = try await mock.signIn(email: "test@test.com", password: "wrong")
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? AuthError, .invalidCredentials)
        }
    }
}
