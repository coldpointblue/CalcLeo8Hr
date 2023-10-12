import os

/// Supported log message types
enum CalculatorLogType {
    case info, error, warning
}

struct Logger {
    static func log(_ message: String, type: CalculatorLogType = .info) {
        switch type {
        case .info:
            os_log("INFO: %{public}@", message)
        case .error:
            os_log("ERROR: %{public}@", message)
        case .warning:
            os_log("WARNING: %{public}@", message)
        }
    }
    
    /// Logs for debug builds only
    static func debugInfo(_ message: String) {
#if DEBUG
        Logger.log(message, type: .info)
#endif
    }
}
