import Foundation
import SwiftUI
import RealmSwift

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var budgetStatus: BudgetStatus?
    @Published var income: Double = 0
    @Published var expenses: Double = 0
    @Published var invested: Double = 0
    
    private let store: FinanceStore
    private let budgetEngine: BudgetEngine
    
    init(store: FinanceStore, rule: BudgetRule = BudgetRule()) {
        self.store = store
        self.budgetEngine = BudgetEngine(rule: rule)
    }
    
    func loadCurrentMonth() {
        let now = Date()
        let year = now.yearComponent
        let month = now.monthComponent
        
        let totals = store.currentYearTotals(year: year)
        income = totals.income
        expenses = totals.expenses
        invested = totals.invested
        
        let detail = store.monthlyDetail(forLastYearWindowFrom: now)
        let currentMonthExpenses = detail.expenses.filter { $0.year == year && $0.month == month }
        
        budgetStatus = budgetEngine.evaluate(income: income, expenses: currentMonthExpenses)
    }
}
