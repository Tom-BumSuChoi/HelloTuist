import Foundation

public protocol StorageClientType {
    func save<T: Encodable>(_ value: T, forKey key: String) throws
    func load<T: Decodable>(forKey key: String) throws -> T?
    func delete(forKey key: String)
    func exists(forKey key: String) -> Bool
}

public enum StorageError: Error, Equatable {
    case encodingFailed
    case decodingFailed
    case notFound
}
