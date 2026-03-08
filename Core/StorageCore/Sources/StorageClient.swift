import Foundation
import StorageCoreInterface

public final class StorageClient: StorageClientType {
    private let defaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(suiteName: String? = nil) {
        self.defaults = suiteName.flatMap { UserDefaults(suiteName: $0) } ?? .standard
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }

    public func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let data = try encoder.encode(value)
        defaults.set(data, forKey: key)
    }

    public func load<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try decoder.decode(T.self, from: data)
    }

    public func delete(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    public func exists(forKey key: String) -> Bool {
        defaults.object(forKey: key) != nil
    }
}
