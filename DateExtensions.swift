import Foundation

extension Date {
    var yearComponent: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var monthComponent: Int {
        Calendar.current.component(.month, from: self)
    }
    
    func monthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
    
    func shortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    static func from(year: Int, month: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return Calendar.current.date(from: components)
    }
}
