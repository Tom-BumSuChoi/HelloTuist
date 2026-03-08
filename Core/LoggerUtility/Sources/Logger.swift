import Foundation
import LoggerUtilityInterface

public final class Logger: LoggerType {
    public static let shared = Logger()

    private let minimumLevel: LogLevel
    private let dateFormatter: DateFormatter

    public init(minimumLevel: LogLevel = .debug) {
        self.minimumLevel = minimumLevel
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }

    public func log(_ level: LogLevel, _ message: String, file: String, function: String, line: Int) {
        guard level >= minimumLevel else { return }
        let timestamp = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let prefix = levelPrefix(level)
        print("[\(timestamp)] \(prefix) [\(fileName):\(line)] \(function) → \(message)")
    }

    private func levelPrefix(_ level: LogLevel) -> String {
        switch level {
        case .debug: return "🔍 DEBUG"
        case .info: return "ℹ️ INFO"
        case .warning: return "⚠️ WARN"
        case .error: return "❌ ERROR"
        case .fatal: return "💀 FATAL"
        }
    }
}
