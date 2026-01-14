import Foundation
import SwiftUI
import RealmSwift

@MainActor
class EntryFormViewModel: ObservableObject {
    @Published var entryType: EntryType = .expense
    @Published var amount: String = ""
    @Published var description: String = ""
    @Published var category: ExpenseCategory = .necessities
    @Published var date: Date = Date()
    @Published var year: Int = Date().yearComponent
    @Published var month: Int = Date().monthComponent
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let store: FinanceStore
    
    enum EntryType: String, CaseIterable {
        case expense = "Expense"
        case income = "Income"
        case investment = "Investment"
    }
    
    init(store: FinanceStore) {
        self.store = store
    }
    
    func submitEntry() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            alertMessage = "Please enter a valid amount"
            showAlert = true
            return
        }
        
        do {
            switch entryType {
            case .expense:
                guard !description.isEmpty else {
                    alertMessage = "Please enter a description"
                    showAlert = true
                    return
                }
                try store.addExpense(date: date, description: description, category: category, amount: amountValue)
            case .income:
                try store.addIncome(year: year, month: month, amount: amountValue)
            case .investment:
                try store.addInvestment(year: year, month: month, amount: amountValue)
            }
            
            // Reset form
            amount = ""
            description = ""
            date = Date()
            year = Date().yearComponent
            month = Date().monthComponent
            
            alertMessage = "\(entryType.rawValue) added successfully!"
            showAlert = true
        } catch {
            alertMessage = "Error: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
