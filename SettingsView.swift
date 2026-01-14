import SwiftUI

struct SettingsView: View {
    let onClose: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("App Information")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Bundle ID")
                        Spacer()
                        Text("com.paco.BudgetingApp")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                
                Section(header: Text("Privacy")) {
                    Text("All data is stored locally on your device using Realm. No data is sent to external servers.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Notifications")) {
                    Button(action: {
                        NotificationsManager.scheduleExpenseReminder()
                    }) {
                        HStack {
                            Image(systemName: "bell.badge")
                            Text("Remind me to log expenses")
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        NotificationsManager.cancelAllNotifications()
                    }) {
                        HStack {
                            Image(systemName: "bell.slash")
                            Text("Cancel all reminders")
                            Spacer()
                        }
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("Budget Rules")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Default Allocation:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("• Necessities: 30%")
                            .font(.caption)
                        Text("• Discretionary: 10%")
                            .font(.caption)
                        Text("• Investments: 60%")
                            .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
