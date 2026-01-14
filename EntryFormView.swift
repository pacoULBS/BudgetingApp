import SwiftUI

struct EntryFormView: View {
    @StateObject private var viewModel: EntryFormViewModel
    
    init(store: FinanceStore) {
        _viewModel = StateObject(wrappedValue: EntryFormViewModel(store: store))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entry Type")) {
                    Picker("Type", selection: $viewModel.entryType) {
                        ForEach(EntryFormViewModel.EntryType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Amount")) {
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                }
                
                if viewModel.entryType == .expense {
                    Section(header: Text("Expense Details")) {
                        TextField("Description", text: $viewModel.description)
                        
                        Picker("Category", selection: $viewModel.category) {
                            ForEach(ExpenseCategory.allCases) { category in
                                Text(category.displayName).tag(category)
                            }
                        }
                        
                        DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    }
                }
                
                if viewModel.entryType == .income || viewModel.entryType == .investment {
                    Section(header: Text("Period")) {
                        Stepper("Year: \(viewModel.year)", value: $viewModel.year, in: 2020...2030)
                        Stepper("Month: \(viewModel.month)", value: $viewModel.month, in: 1...12)
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.submitEntry()
                    }) {
                        HStack {
                            Spacer()
                            Text("Add \(viewModel.entryType.rawValue)")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Add Entry")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Status"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
