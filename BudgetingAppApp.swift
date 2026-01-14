import SwiftUI
import RealmSwift

@main
struct BudgetingAppApp: App {
    @StateObject private var store = FinanceStore()
    @State private var showSettings = false

    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView(store: store)
                    .tabItem { Label("Dashboard", systemImage: "chart.pie") }

                HistoryView(store: store)
                    .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }

                EntryFormView(store: store)
                    .tabItem { Label("Add", systemImage: "plus.circle") }

                SettingsView(onClose: { showSettings = false })
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            .onAppear {
                NotificationsManager.requestPermission()
            }
        }
    }
}