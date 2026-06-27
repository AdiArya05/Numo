import SwiftUI

struct ExpenseHomeView: View {
    let transactions: [TransactionItem]
    @Binding var selectedPeriod: TimePeriod
    @Binding var ledgerMode: LedgerMode
    @Binding var isAddMenuPresented: Bool
    let onSelectEntry: (EntryKind) -> Void
    @State private var selectedTransaction: TransactionItem?
    @Namespace private var periodSelectionGlass

    private var visibleTransactions: [TransactionItem] {
        let kind: EntryKind = ledgerMode == .income ? .income : .expense
        return Array(transactions.filter { $0.kind == kind }.prefix(4))
    }

    private var expenditure: Decimal {
        transactions
            .filter { $0.kind == .expense }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }

    private var income: Decimal {
        transactions
            .filter { $0.kind == .income }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack(alignment: .bottom) {
                    NumoTheme.background
                        .ignoresSafeArea()

                    homeContent(bottomInset: max(proxy.safeAreaInsets.bottom, 10) + 66)
                        .blur(radius: isAddMenuPresented ? 8 : 0)
                        .scaleEffect(isAddMenuPresented ? 0.975 : 1)
                        .animation(.smooth(duration: 0.4), value: isAddMenuPresented)
                        .allowsHitTesting(!isAddMenuPresented)

                    if isAddMenuPresented {
                        Color.clear
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                    isAddMenuPresented = false
                                }
                            }
                            .transition(.opacity)

                        AddActionMenu(onSelect: onSelectEntry)
                            .padding(.trailing, 24)
                            .padding(.bottom, max(proxy.safeAreaInsets.bottom, 12) + 72)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .transition(.scale(scale: 0.82, anchor: .bottomTrailing).combined(with: .opacity))
                    }

                    HomeNavigationBar(
                        selectedMode: $ledgerMode,
                        isAddMenuPresented: $isAddMenuPresented,
                        bottomInset: max(proxy.safeAreaInsets.bottom, 10)
                    )
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: SummaryDestination.self) { destination in
                SummaryDetailView(destination: destination)
            }
        }
        .statusBarHidden(false)
        .sheet(item: $selectedTransaction) { transaction in
            TransactionDetailSheet(transaction: transaction)
                .presentationDetents([.height(348)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(36)
                .presentationBackground(.ultraThinMaterial)
        }
    }

    private func homeContent(bottomInset: CGFloat) -> some View {
        VStack(spacing: 13) {
            periodPicker
            expenditureAmount
            RecentActivityCard(
                transactions: visibleTransactions,
                onSelect: { selectedTransaction = $0 }
            )
            compactCards
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, bottomInset)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private var periodPicker: some View {
        GlassEffectContainer(spacing: 6) {
            HStack(spacing: 0) {
                ForEach(TimePeriod.allCases) { period in
                    Button {
                        withAnimation(.spring(response: 0.36, dampingFraction: 0.82)) {
                            selectedPeriod = period
                        }
                    } label: {
                        Text(period.rawValue)
                            .font(.headline.bold())
                            .foregroundStyle(selectedPeriod == period ? .white : .white.opacity(0.64))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .contentShape(Rectangle())
                            .background {
                                if selectedPeriod == period {
                                    Capsule()
                                        .fill(Color.white.opacity(0.035))
                                        .glassEffect(.regular.interactive(), in: Capsule())
                                        .glassEffectID("period-selection", in: periodSelectionGlass)
                                        .glassEffectTransition(.matchedGeometry)
                                        .overlay {
                                            Capsule()
                                                .stroke(Color.white.opacity(0.24), lineWidth: 0.7)
                                        }
                                        .padding(3)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selectedPeriod == period ? .isSelected : [])
                }
            }
            .glassEffect(.regular.interactive(), in: Capsule())
        }
        .accessibilityLabel("Expenditure time period")
    }

    private var expenditureAmount: some View {
        Text(ledgerMode == .expenses ? formattedExpenditure : formattedIncome)
            .font(.system(size: 60, weight: .bold, design: .default))
            .minimumScaleFactor(0.65)
            .lineLimit(1)
            .contentTransition(.numericText())
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .accessibilityLabel(ledgerMode == .expenses ? "Total expenditure \(formattedExpenditure)" : "Total income \(formattedIncome)")
    }

    private var formattedExpenditure: String {
        formatted(expenditure)
    }

    private var formattedIncome: String {
        formatted(income)
    }

    private func formatted(_ amount: Decimal) -> String {
        let value = NSDecimalNumber(decimal: amount).doubleValue
        if value.rounded() == value {
            return value >= 1_000 ? String(format: "$%.0f", value) : String(format: "$%.0f", value)
        }
        return String(format: "$%.2f", value)
    }

    private var compactCards: some View {
        HStack(alignment: .top, spacing: 18) {
            NavigationLink(value: SummaryDestination.recurring) {
                CompactSummaryCard(
                    title: "Recurring Expenses",
                    accent: NumoTheme.recurring,
                    items: [
                        .init(emoji: "☁️", title: "iCloud+", detail: "$3.99"),
                        .init(emoji: "🎵", title: "Spotify", detail: "$12.99"),
                        .init(emoji: "💳", title: "ChatGPT", detail: "$29.99")
                    ]
                )
            }
            .buttonStyle(.plain)

            NavigationLink(value: SummaryDestination.categories) {
                CompactSummaryCard(
                    title: "Top Categories",
                    accent: NumoTheme.categories,
                    items: [
                        .init(emoji: "🏠", title: "Housing", detail: "$299.99"),
                        .init(emoji: "🥼", title: "Shopping", detail: "$49.90"),
                        .init(emoji: "🌮", title: "Food", detail: "$8.50")
                    ]
                )
            }
            .buttonStyle(.plain)
        }
    }
}

private struct RecentActivityCard: View {
    let transactions: [TransactionItem]
    let onSelect: (TransactionItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Recent Activity")
                .font(.headline.bold())
                .padding(.bottom, 16)

            Rectangle()
                .fill(NumoTheme.divider)
                .frame(height: 1)
                .padding(.bottom, 15)

            VStack(spacing: 10) {
                ForEach(transactions) { transaction in
                    Button {
                        onSelect(transaction)
                    } label: {
                        TransactionRow(transaction: transaction)
                    }
                    .buttonStyle(ActivityRowButtonStyle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(height: 278)
        .numoCard(cornerRadius: 36)
    }
}

private struct ActivityRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.horizontal, configuration.isPressed ? 8 : 0)
            .padding(.vertical, 2)
            .background(
                Color.white.opacity(configuration.isPressed ? 0.08 : 0),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

private struct TransactionRow: View {
    let transaction: TransactionItem

    var body: some View {
        HStack(spacing: 12) {
            Text(transaction.emoji)
                .font(.body)
                .frame(width: 40, height: 40)
                .background(categoryColor.opacity(0.36), in: Circle())
                .overlay {
                    Circle().stroke(Color.white.opacity(0.40), lineWidth: 0.7)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.title)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Text(transaction.timestamp)
                    .font(.caption.bold())
                    .foregroundStyle(NumoTheme.secondaryText)
            }

            Spacer(minLength: 6)

            Text(transaction.signedAmount)
                .font(.subheadline.bold())
                .monospacedDigit()
                .foregroundStyle(transaction.kind == .income ? NumoTheme.mint : .white)
        }
    }

    private var categoryColor: Color {
        switch transaction.category {
        case "Food": Color.yellow
        case "Shopping": Color.gray
        case "Housing": Color.teal
        default: Color.cyan
        }
    }
}

private struct CompactSummaryCard: View {
    let title: String
    let accent: Color
    let items: [CompactStat]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .padding(.bottom, 10)

            Rectangle()
                .fill(NumoTheme.divider)
                .frame(height: 1)
                .padding(.bottom, 12)

            VStack(spacing: 11) {
                ForEach(items) { item in
                    HStack(spacing: 7) {
                        Text(item.emoji)
                            .font(.footnote)

                        Text(item.title)
                            .font(.caption.bold())
                            .lineLimit(1)

                        Spacer(minLength: 2)

                        Text(item.detail)
                            .font(.caption2.bold())
                            .foregroundStyle(Color.white.opacity(0.76))
                            .monospacedDigit()
                    }
                }
            }
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: 150, alignment: .topLeading)
        .background(
            LinearGradient(
                colors: [accent.opacity(0.18), NumoTheme.surface],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(accent.opacity(0.46), lineWidth: 0.9)
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(accent)
                .padding(16)
        }
    }
}
