import Foundation
import RealmSwift

enum ExpenseCategory: String, PersistableEnum, CaseIterable, Identifiable {
    case necessities, discretionary, investments, misc
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .necessities: return "Necessities"
        case .discretionary: return "Discretionary"
        case .investments: return "Investments"
        case .misc: return "Misc"
        }
    }
}

final class IncomeMonth: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var year: Int
    @Persisted var month: Int // 1-12
    @Persisted var amount: Double
}

final class Expense: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var descriptionText: String
    @Persisted var category: ExpenseCategory
    @Persisted var amount: Double
    @Persisted var year: Int
    @Persisted var month: Int
}

final class InvestmentMonth: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var year: Int
    @Persisted var month: Int
    @Persisted var amount: Double
    @Persisted var cumulativeYTD: Double // convenience cache
}

final class YearAggregate: Object, Identifiable {
    @Persisted(primaryKey: true) var year: Int
    @Persisted var totalIncome: Double
    @Persisted var totalExpenses: Double
    @Persisted var totalInvested: Double
}