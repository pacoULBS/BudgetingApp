import Foundation
import SwiftUI
import RealmSwift

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let store: FinanceStore
    
    init(store: FinanceStore) {
        self.store = store
    }
    
    func loadExpenses() {
        let detail = store.monthlyDetail(forLastYearWindowFrom: Date())
        expenses = detail.expenses.sorted { $0.date > $1.date }
    }
    
    func deleteExpense(_ expense: Expense) {
        do {
            try store.deleteExpense(id: expense.id)
            loadExpenses()
            alertMessage = "Expense deleted successfully"
            showAlert = true
        } catch {
            alertMessage = "Error deleting expense: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
