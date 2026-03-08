import Foundation

public struct Endpoint {
    public let path: String
    public let method: HTTPMethod
    public let headers: [String: String]
    public let queryItems: [URLQueryItem]
    public let body: Data?

    public init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed
    case noData
    case unknown
}
