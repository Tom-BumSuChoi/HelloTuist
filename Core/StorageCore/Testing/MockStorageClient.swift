import Foundation
import StorageCoreInterface

public final class MockStorageClient: StorageClientType {
    public var storage: [String: Data] = [:]

    public init() {}

    public func save<T: Encodable>(_ value: T, forKey key: String) throws {
        storage[key] = try JSONEncoder().encode(value)
    }

    public func load<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = storage[key] else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func delete(forKey key: String) {
        storage.removeValue(forKey: key)
    }

    public func exists(forKey key: String) -> Bool {
        storage[key] != nil
    }
}
