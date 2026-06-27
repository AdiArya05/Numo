import SwiftUI

struct TransactionDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let transaction: TransactionItem

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Transaction")
                    .font(.headline.bold())

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.subheadline.bold())
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: Circle())
                .accessibilityLabel("Close transaction")
            }

            HStack(spacing: 16) {
                Text(transaction.emoji)
                    .font(.largeTitle)
                    .frame(width: 68, height: 68)
                    .background(categoryColor.opacity(0.25), in: Circle())
                    .overlay {
                        Circle().stroke(categoryColor.opacity(0.58), lineWidth: 1)
                    }

                VStack(alignment: .leading, spacing: 5) {
                    Text(transaction.title)
                        .font(.title3.bold())
                        .lineLimit(2)

                    Text(transaction.category)
                        .font(.subheadline.bold())
                        .foregroundStyle(categoryColor)
                }

                Spacer(minLength: 4)
            }

            HStack {
                detailCell(title: "Amount", value: transaction.signedAmount, symbol: "dollarsign")
                detailCell(title: "Paid", value: transaction.timestamp, symbol: "calendar")
                detailCell(
                    title: "Type",
                    value: transaction.isRecurring ? "Recurring" : "One-time",
                    symbol: transaction.isRecurring ? "arrow.trianglehead.2.clockwise.rotate.90" : "creditcard"
                )
            }
            .padding(14)
            .background(Color.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .padding(.horizontal, 22)
        .padding(.top, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private func detailCell(title: String, value: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: symbol)
                .font(.subheadline.bold())
                .foregroundStyle(categoryColor)

            Text(title)
                .font(.caption2.bold())
                .foregroundStyle(NumoTheme.secondaryText)

            Text(value)
                .font(.caption.bold())
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var categoryColor: Color {
        switch transaction.category {
        case "Food": .yellow
        case "Shopping": .gray
        case "Housing": .teal
        case "Subscriptions": NumoTheme.recurring
        default: NumoTheme.activity
        }
    }
}

struct SummaryDetailView: View {
    let destination: SummaryDestination

    private var accent: Color {
        destination == .recurring ? NumoTheme.recurring : NumoTheme.categories
    }

    private var items: [SummaryDetailItem] {
        switch destination {
        case .recurring:
            [
                .init(emoji: "💳", title: "ChatGPT", subtitle: "Renews 22 July", amount: "$29.99"),
                .init(emoji: "🎵", title: "Spotify", subtitle: "Renews 2 July", amount: "$12.99"),
                .init(emoji: "☁️", title: "iCloud+", subtitle: "Renews 18 July", amount: "$3.99"),
                .init(emoji: "🎬", title: "Netflix", subtitle: "Renews 9 July", amount: "$18.98"),
                .init(emoji: "🏋️", title: "Gym membership", subtitle: "Renews 1 July", amount: "$48.00"),
                .init(emoji: "📱", title: "Mobile plan", subtitle: "Renews 15 July", amount: "$35.00")
            ]
        case .categories:
            [
                .init(emoji: "🏠", title: "Housing", subtitle: "1 transaction", amount: "$299.99"),
                .init(emoji: "🥼", title: "Shopping", subtitle: "1 transaction", amount: "$49.90"),
                .init(emoji: "💳", title: "Subscriptions", subtitle: "3 transactions", amount: "$46.97"),
                .init(emoji: "🌮", title: "Food", subtitle: "1 transaction", amount: "$8.50"),
                .init(emoji: "🚕", title: "Transport", subtitle: "No spending yet", amount: "$0.00"),
                .init(emoji: "🎬", title: "Entertainment", subtitle: "No spending yet", amount: "$0.00")
            ]
        }
    }

    var body: some View {
        Group {
            if destination == .categories {
                categoriesBody
            } else {
                recurringBody
            }
        }
        .navigationTitle(destination.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.visible, for: .navigationBar)
        .tint(.white)
    }

    private var recurringBody: some View {
        ZStack {
            NumoTheme.background
                .ignoresSafeArea()

            List {
                summaryHeader
                    .listRowInsets(EdgeInsets(top: 12, leading: 18, bottom: 18, trailing: 18))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                Section {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        HStack(spacing: 15) {
                            Text(item.emoji)
                                .font(.title2)
                                .frame(width: 48, height: 48)
                                .background(accent.opacity(index < 3 ? 0.22 : 0.10), in: Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline.bold())
                                Text(item.subtitle)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(NumoTheme.secondaryText)
                            }

                            Spacer()

                            Text(item.amount)
                                .font(.headline.bold())
                                .monospacedDigit()
                        }
                        .padding(.vertical, 7)
                        .listRowBackground(NumoTheme.surface)
                        .listRowSeparatorTint(Color.white.opacity(0.12))
                    }
                } header: {
                    Text("All")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .textCase(nil)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
        }
    }

    private var categoriesBody: some View {
        ZStack {
            NumoTheme.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 26) {
                Text("$405.36 spent")
                    .font(.title3.bold())
                    .foregroundStyle(Color.white.opacity(0.64))

                CategoryCoinChart(categories: coinCategories)
                    .frame(height: 150)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 18),
                        GridItem(.flexible(), spacing: 18)
                    ],
                    alignment: .leading,
                    spacing: 18
                ) {
                    ForEach(coinCategories) { category in
                        HStack(alignment: .top, spacing: 9) {
                            Capsule()
                                .fill(category.color)
                                .frame(width: 7, height: 18)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(category.name)
                                    .font(.subheadline.bold())

                                Text("\(category.amount) · \(category.percent)%")
                                    .font(.caption.bold())
                                    .foregroundStyle(NumoTheme.secondaryText)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 12)
        }
    }

    private var coinCategories: [CoinCategory] {
        [
            .init(name: "Housing", amount: "$299.99", percent: 74, color: .cyan, thickness: 68),
            .init(name: "Shopping", amount: "$49.90", percent: 12, color: .green, thickness: 40),
            .init(name: "Subscriptions", amount: "$29.99", percent: 7, color: .pink, thickness: 32),
            .init(name: "Food", amount: "$8.50", percent: 2, color: .yellow, thickness: 24),
            .init(name: "Transport", amount: "$7.00", percent: 2, color: .orange, thickness: 22),
            .init(name: "Entertainment", amount: "$5.00", percent: 1, color: .purple, thickness: 20),
            .init(name: "Health", amount: "$3.00", percent: 1, color: .mint, thickness: 18),
            .init(name: "Other", amount: "$1.98", percent: 1, color: .indigo, thickness: 18)
        ]
    }

    private var summaryHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(destination == .recurring ? "$148.95" : "$405.36")
                    .font(.largeTitle.bold())
                    .monospacedDigit()

                Text(destination == .recurring ? "expected each month" : "across 4 categories")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.white.opacity(0.64))
            }

            Spacer()

            Image(systemName: destination.symbol)
                .font(.title2.bold())
                .foregroundStyle(accent)
                .frame(width: 54, height: 54)
                .glassEffect(.regular.tint(accent.opacity(0.22)), in: Circle())
        }
        .padding(20)
        .glassEffect(.regular.tint(accent.opacity(0.12)), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

private struct CategoryCoinChart: View {
    let categories: [CoinCategory]

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: -5) {
                ForEach(categories) { category in
                    SpendingCoin(
                        color: category.color,
                        thickness: category.thickness
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.12),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 8,
                            endRadius: proxy.size.width * 0.46
                        )
                    )
                    .blur(radius: 20)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Spending by category shown as weighted coins")
    }
}

private struct SpendingCoin: View {
    let color: Color
    let thickness: CGFloat

    var body: some View {
        ZStack(alignment: .trailing) {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.72), color, color.opacity(0.58)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Ellipse()
                .fill(color.opacity(0.86))
                .frame(width: 13)
                .overlay {
                    Ellipse()
                        .stroke(Color.white.opacity(0.48), lineWidth: 0.8)
                }

            Ellipse()
                .stroke(Color.black.opacity(0.35), lineWidth: 0.8)
                .frame(width: 13)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: thickness, height: 58)
        .shadow(color: color.opacity(0.30), radius: 11, y: 8)
    }
}

private struct CoinCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
    let percent: Int
    let color: Color
    let thickness: CGFloat
}

private struct SummaryDetailItem: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let subtitle: String
    let amount: String
}
