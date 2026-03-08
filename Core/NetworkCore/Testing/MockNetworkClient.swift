import Foundation
import NetworkCoreInterface

public final class MockNetworkClient: NetworkClientType {
    public var mockData: Data?
    public var mockError: Error?
    public var requestedEndpoints: [Endpoint] = []

    public init() {}

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        requestedEndpoints.append(endpoint)
        if let error = mockError { throw error }
        guard let data = mockData else { throw NetworkError.noData }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func request(_ endpoint: Endpoint) async throws -> Data {
        requestedEndpoints.append(endpoint)
        if let error = mockError { throw error }
        guard let data = mockData else { throw NetworkError.noData }
        return data
    }
}
