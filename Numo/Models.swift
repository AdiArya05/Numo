import Foundation

enum TimePeriod: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var id: Self { self }
}

enum LedgerMode: String, CaseIterable, Identifiable {
    case income = "Income"
    case expenses = "Expenses"

    var id: Self { self }

    var symbol: String {
        switch self {
        case .income: "arrow.down.left"
        case .expenses: "arrow.up.right"
        }
    }
}

enum EntryKind: String, Identifiable {
    case income = "Income"
    case expense = "Expense"

    var id: Self { self }

    var symbol: String {
        switch self {
        case .income: "plus"
        case .expense: "minus"
        }
    }
}

enum SummaryDestination: String, Hashable {
    case recurring = "Recurring Expenses"
    case categories = "Top Categories"

    var symbol: String {
        switch self {
        case .recurring: "arrow.trianglehead.2.clockwise.rotate.90"
        case .categories: "square.grid.2x2.fill"
        }
    }
}

struct TransactionItem: Identifiable {
    let id = UUID()
    let kind: EntryKind
    let emoji: String
    let title: String
    let timestamp: String
    let amount: Decimal
    let category: String
    let isRecurring: Bool

    var signedAmount: String {
        let value = NSDecimalNumber(decimal: amount).doubleValue
        return String(format: kind == .income ? "+$%.2f" : "-$%.2f", value)
    }

    init(
        kind: EntryKind = .expense,
        emoji: String,
        title: String,
        timestamp: String,
        amount: Decimal,
        category: String,
        isRecurring: Bool
    ) {
        self.kind = kind
        self.emoji = emoji
        self.title = title
        self.timestamp = timestamp
        self.amount = amount
        self.category = category
        self.isRecurring = isRecurring
    }
}

struct NewTransactionDraft {
    let kind: EntryKind
    let amount: Decimal
    let title: String
    let category: String
    let date: Date
}

struct CompactStat: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let detail: String
}

extension TransactionItem {
    static let samples: [TransactionItem] = [
        .init(emoji: "🌮", title: "Guzman Y Gomez", timestamp: "25 June 20:45", amount: 8.50, category: "Food", isRecurring: false),
        .init(emoji: "🥼", title: "Zara", timestamp: "30 June 09:30", amount: 49.90, category: "Shopping", isRecurring: false),
        .init(emoji: "💳", title: "ChatGPT Subscription", timestamp: "22 June 09:30", amount: 29.99, category: "Subscriptions", isRecurring: true),
        .init(emoji: "🏠", title: "Rent", timestamp: "22 June 09:30", amount: 299.99, category: "Housing", isRecurring: true),
        .init(emoji: "🧾", title: "Other spending", timestamp: "Earlier this week", amount: 611.62, category: "Other", isRecurring: false),
        .init(kind: .income, emoji: "💼", title: "Salary", timestamp: "25 June 08:00", amount: 4_200, category: "Salary", isRecurring: true),
        .init(kind: .income, emoji: "💻", title: "Freelance", timestamp: "18 June 14:30", amount: 500, category: "Freelance", isRecurring: false),
        .init(kind: .income, emoji: "↩️", title: "Cashback", timestamp: "12 June 11:20", amount: 100, category: "Refund", isRecurring: false)
    ]
}
