import SwiftUI

struct ContentView: View {
    @State private var transactions = TransactionItem.samples
    @State private var selectedPeriod = TimePeriod.week
    @State private var ledgerMode = LedgerMode.expenses
    @State private var isAddMenuPresented = false
    @State private var activeEntry: EntryKind?

    var body: some View {
        ExpenseHomeView(
            transactions: transactions,
            selectedPeriod: $selectedPeriod,
            ledgerMode: $ledgerMode,
            isAddMenuPresented: $isAddMenuPresented,
            onSelectEntry: openEntry
        )
        .fullScreenCover(item: $activeEntry) { kind in
            AmountEntryView(kind: kind) { draft in
                addEntry(draft)
            }
        }
    }

    private func openEntry(_ kind: EntryKind) {
        isAddMenuPresented = false
        activeEntry = kind
    }

    private func addEntry(_ draft: NewTransactionDraft) {
        transactions.insert(
            TransactionItem(
                kind: draft.kind,
                emoji: emoji(for: draft.category),
                title: draft.title,
                timestamp: draft.date.formatted(date: .abbreviated, time: .shortened),
                amount: draft.amount,
                category: draft.category,
                isRecurring: false
            ),
            at: 0
        )
    }

    private func emoji(for category: String) -> String {
        switch category {
        case "Food": "🍔"
        case "Shopping": "🛍️"
        case "Housing": "🏠"
        case "Subscriptions": "💳"
        case "Transport": "🚕"
        case "Salary": "💼"
        case "Freelance": "💻"
        case "Gift": "🎁"
        case "Refund": "↩️"
        default: "🧾"
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
