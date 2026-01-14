import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    
    init(store: FinanceStore) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(store: store))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Monthly Totals
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Year Totals")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Income")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("$\(viewModel.income, specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Expenses")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("$\(viewModel.expenses, specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Invested")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("$\(viewModel.invested, specifier: "%.2f")")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Budget Allocations
                    if let status = viewModel.budgetStatus {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Budget Allocations")
                                .font(.headline)
                            
                            ForEach(ExpenseCategory.allCases) { category in
                                HStack {
                                    Text(category.displayName)
                                        .font(.subheadline)
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("Allocated: $\(status.allocations[category] ?? 0, specifier: "%.2f")")
                                            .font(.caption)
                                        Text("Actual: $\(status.actuals[category] ?? 0, specifier: "%.2f")")
                                            .font(.caption)
                                        let delta = status.deltas[category] ?? 0
                                        Text("Delta: $\(delta, specifier: "%.2f")")
                                            .font(.caption)
                                            .foregroundColor(delta > 0 ? .red : .green)
                                    }
                                }
                                .padding(.vertical, 5)
                                Divider()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.loadCurrentMonth()
            }
        }
    }
}
