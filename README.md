# BudgetingApp

A SwiftUI-based personal budgeting application for iOS that uses Realm for local data storage.

## Features

- **Dashboard**: View monthly income, expenses, and investment totals with budget allocation analysis
- **Expense Tracking**: Add and categorize expenses with support for multiple categories (Necessities, Discretionary, Investments, Misc)
- **Income Management**: Track monthly income entries
- **Investment Tracking**: Record and monitor investment contributions
- **History View**: Browse and delete expense history for the last year
- **Budget Rules**: Follows a default 30/10/60 allocation rule (Necessities/Discretionary/Investments)
- **Local Notifications**: Optional reminders to log expenses
- **Privacy-First**: All data stored locally on your device

## Requirements

- iOS 16.0 or later
- Xcode 14.0 or later
- Swift 5.7 or later
- Realm Swift Package Manager dependency (already configured)

## Build & Run

1. Clone the repository:
   ```bash
   git clone https://github.com/pacoULBS/BudgetingApp.git
   cd BudgetingApp
   ```

2. Open the project in Xcode:
   ```bash
   open BudgetingApp.xcodeproj
   ```

3. Wait for Xcode to resolve Swift Package Manager dependencies (Realm)

4. Select your target device or simulator (iOS 16+)

5. Build and run the project (⌘R)

## Architecture

- **Models**: Realm-based data models for income, expenses, investments, and yearly aggregates
- **Storage**: `FinanceStore` manages CRUD operations and automatic data pruning
- **Budget Engine**: Evaluates spending against budget rules and calculates allocation deltas
- **Views**: SwiftUI-based UI with TabView navigation
- **ViewModels**: MVVM pattern with `@Published` properties for reactive UI updates

## Privacy & Data

All financial data is stored **locally on your device** using Realm database. No data is transmitted to external servers. The app requests notification permissions only to provide optional expense reminders.

## Bundle ID

`com.paco.BudgetingApp`

## License

This project is provided as-is for personal use.
