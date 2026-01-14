import Foundation
import RealmSwift

struct BudgetStatus {
    let allocations: [ExpenseCategory: Double]
    let actuals: [ExpenseCategory: Double]
    let deltas: [ExpenseCategory: Double]
    let income: Double
    let invested: Double
}

struct BudgetEngine {
    let rule: BudgetRule

    func evaluate(income: Double, expenses: [Expense]) -> BudgetStatus {
        var actuals: [ExpenseCategory: Double] = [:]
        ExpenseCategory.allCases.forEach { actuals[$0] = 0 }
        expenses.forEach { actuals[$0.category, default: 0] += $0.amount }

        let allocations: [ExpenseCategory: Double] = [
            .necessities: income * rule.necessities,
            .discretionary: income * rule.discretionary,
            .investments: income * rule.investments,
            .misc: 0 // intentionally zero; misc rolls into discretionary overage
        ]

        var deltas: [ExpenseCategory: Double] = [:]
        ExpenseCategory.allCases.forEach { cat in
            let target = allocations[cat] ?? 0
            deltas[cat] = (actuals[cat] ?? 0) - target
        }

        let invested = allocations[.investments] ?? 0
        return BudgetStatus(allocations: allocations, actuals: actuals, deltas: deltas, income: income, invested: invested)
    }
}