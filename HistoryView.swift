import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    
    init(store: FinanceStore) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(store: store))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.expenses) { expense in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(expense.descriptionText)
                                .font(.headline)
                            Spacer()
                            Text("$\(expense.amount, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        HStack {
                            Text(expense.category.displayName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(expense.date.shortDate())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let expense = viewModel.expenses[index]
                        viewModel.deleteExpense(expense)
                    }
                }
            }
            .navigationTitle("Expense History")
            .onAppear {
                viewModel.loadExpenses()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                    viewModel.loadExpenses()
                })
            }
        }
    }
}
