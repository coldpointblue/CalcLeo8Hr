import os

enum CalculatorLogType {
    case info, error
}

struct Logger {
    static func log(_ message: String, type: CalculatorLogType = .info) {
        switch type {
        case .info:
            os_log("INFO: %{public}@", message)
        case .error:
            os_log("ERROR: %{public}@", message)
        }
    }
}
