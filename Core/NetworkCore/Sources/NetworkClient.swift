import Foundation
import NetworkCoreInterface
import Alamofire

public final class NetworkClient: NetworkClientType {
    private let baseURL: String
    private let session: Session

    public init(baseURL: String = "https://api.nomadspace.io", session: Session = .default) {
        self.baseURL = baseURL
        self.session = session
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    public func request(_ endpoint: Endpoint) async throws -> Data {
        let url = try buildURL(for: endpoint)
        let method = Alamofire.HTTPMethod(rawValue: endpoint.method.rawValue)

        let response = await session.request(
            url,
            method: method,
            headers: HTTPHeaders(endpoint.headers.map { HTTPHeader(name: $0.key, value: $0.value) })
        )
        .validate()
        .serializingData()
        .response

        guard let data = response.data else {
            throw NetworkError.noData
        }

        if let statusCode = response.response?.statusCode, !(200...299).contains(statusCode) {
            throw NetworkError.httpError(statusCode: statusCode)
        }

        return data
    }

    private func buildURL(for endpoint: Endpoint) throws -> URL {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}
