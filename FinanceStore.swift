import Foundation
import RealmSwift

struct BudgetRule: Codable {
    var necessities: Double = 0.30
    var discretionary: Double = 0.10
    var investments: Double = 0.60

    var isValid: Bool {
        abs((necessities + discretionary + investments) - 1.0) < 0.0001
    }
}

final class FinanceStore: ObservableObject {
    private let realm: Realm
    private let calendar = Calendar.current

    init(realm: Realm = try! RealmProvider.realm()) {
        self.realm = realm
        pruneOldDataIfNeeded()
    }

    // MARK: - CRUD

    func addIncome(year: Int, month: Int, amount: Double) throws {
        try realm.write {
            let rec = IncomeMonth()
            rec.year = year; rec.month = month; rec.amount = amount
            realm.add(rec, update: .modified)
        }
        pruneOldDataIfNeeded()
    }

    func addExpense(date: Date, description: String, category: ExpenseCategory, amount: Double) throws {
        let comps = calendar.dateComponents([.year, .month], from: date)
        guard let y = comps.year, let m = comps.month else { return }
        try realm.write {
            let e = Expense()
            e.date = date
            e.descriptionText = description
            e.category = category
            e.amount = amount
            e.year = y
            e.month = m
            realm.add(e)
        }
        pruneOldDataIfNeeded()
    }

    func addInvestment(year: Int, month: Int, amount: Double) throws {
        try realm.write {
            let inv = realm.objects(InvestmentMonth.self)
                .where { $0.year == year && $0.month == month }
                .first ?? InvestmentMonth()
            if inv.realm == nil {
                inv.year = year; inv.month = month; inv.amount = 0
            }
            inv.amount += amount
            realm.add(inv, update: .modified)
            updateCumulativeForYear(year: year)
        }
        pruneOldDataIfNeeded()
    }

    func deleteExpense(id: ObjectId) throws {
        if let obj = realm.object(ofType: Expense.self, forPrimaryKey: id) {
            try realm.write { realm.delete(obj) }
        }
    }

    func deleteIncome(id: ObjectId) throws {
        if let obj = realm.object(ofType: IncomeMonth.self, forPrimaryKey: id) {
            try realm.write { realm.delete(obj) }
        }
    }

    func deleteInvestment(id: ObjectId) throws {
        if let obj = realm.object(ofType: InvestmentMonth.self, forPrimaryKey: id) {
            try realm.write { realm.delete(obj) }
        }
    }

    // MARK: - Queries

    func monthlyDetail(forLastYearWindowFrom reference: Date = Date()) -> (incomes: [IncomeMonth], expenses: [Expense], investments: [InvestmentMonth]) {
        let windowYears = detailYears(reference: reference)
        let incomes = Array(realm.objects(IncomeMonth.self).where { windowYears.contains($0.year) })
        let expenses = Array(realm.objects(Expense.self).where { windowYears.contains($0.year) })
        let investments = Array(realm.objects(InvestmentMonth.self).where { windowYears.contains($0.year) })
        return (incomes, expenses, investments)
    }

    func yearlyAggregates(excluding years: Set<Int>) -> [YearAggregate] {
        Array(realm.objects(YearAggregate.self).where { !years.contains($0.year) }).sorted { $0.year < $1.year }
    }

    func currentYearTotals(year: Int) -> (income: Double, expenses: Double, invested: Double) {
        let income = realm.objects(IncomeMonth.self).where { $0.year == year }.sum(of: \ .amount)
        let expenses = realm.objects(Expense.self).where { $0.year == year }.sum(of: \ .amount)
        let invested = realm.objects(InvestmentMonth.self).where { $0.year == year }.sum(of: \ .amount)
        return (income, expenses, invested)
    }

    // MARK: - Pruning

    private func pruneOldDataIfNeeded(reference: Date = Date()) {
        let cutoffYear = calendar.component(.year, from: reference) - 1
        let oldIncome = realm.objects(IncomeMonth.self).where { $0.year < cutoffYear }
        let oldExpenses = realm.objects(Expense.self).where { $0.year < cutoffYear }
        let oldInvestments = realm.objects(InvestmentMonth.self).where { $0.year < cutoffYear }

        guard !(oldIncome.isEmpty && oldExpenses.isEmpty && oldInvestments.isEmpty) else { return }

        try? realm.write {
            let incomeByYear = Dictionary(grouping: oldIncome, by: \ .year).mapValues { $0.reduce(0) { $0 + $1.amount } }
            let expenseByYear = Dictionary(grouping: oldExpenses, by: \ .year).mapValues { $0.reduce(0) { $0 + $1.amount } }
            let investByYear = Dictionary(grouping: oldInvestments, by: \ .year).mapValues { $0.reduce(0) { $0 + $1.amount } }

            let years = Set(incomeByYear.keys).union(expenseByYear.keys).union(investByYear.keys)
            for y in years {
                let agg = realm.object(ofType: YearAggregate.self, forPrimaryKey: y) ?? YearAggregate()
                if agg.realm == nil { agg.year = y }
                agg.totalIncome += incomeByYear[y] ?? 0
                agg.totalExpenses += expenseByYear[y] ?? 0
                agg.totalInvested += investByYear[y] ?? 0
                realm.add(agg, update: .modified)
            }

            realm.delete(oldIncome)
            realm.delete(oldExpenses)
            realm.delete(oldInvestments)
        }
    }

    private func updateCumulativeForYear(year: Int) {
        let months = realm.objects(InvestmentMonth.self).where { $0.year == year }.sorted(by: \ .month)
        var running: Double = 0
        months.forEach { m in
            running += m.amount
            m.cumulativeYTD = running
        }
    }

    private func detailYears(reference: Date) -> Set<Int> {
        let currentYear = calendar.component(.year, from: reference)
        return [currentYear, currentYear - 1]
    }
}