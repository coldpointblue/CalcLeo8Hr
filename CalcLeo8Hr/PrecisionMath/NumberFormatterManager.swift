import Foundation

final class NumberFormatterManager {
    static let shared = NumberFormatterManager()
    private var fixedNumberFormatter: NumberFormatter
    private let queue = DispatchQueue(label: "com.CalcLeo8Hr.NumberFormatterManager")
    
    private init() {
        fixedNumberFormatter = NumberFormatter()
        fixedNumberFormatter.numberStyle = .decimal
    }
    
    func getFormatter(withDigits digits: Int) -> NumberFormatter {
        return queue.sync {
            fixedNumberFormatter.minimumFractionDigits = digits
            fixedNumberFormatter.maximumFractionDigits = digits
            return fixedNumberFormatter
        }
    }
}
