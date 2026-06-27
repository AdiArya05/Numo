import SwiftUI

struct AmountEntryView: View {
    @Environment(\.dismiss) private var dismiss

    let kind: EntryKind
    let onConfirm: (NewTransactionDraft) -> Void

    @State private var rawAmount = "0"
    @State private var step = EntryStep.amount
    @State private var title = ""
    @State private var category: String
    @State private var date = Date()
    @FocusState private var isTitleFocused: Bool

    init(kind: EntryKind, onConfirm: @escaping (NewTransactionDraft) -> Void) {
        self.kind = kind
        self.onConfirm = onConfirm
        _category = State(initialValue: kind == .income ? "Salary" : "Food")
    }

    private var amount: Double {
        Double(rawAmount) ?? 0
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                Group {
                    if step == .amount {
                        VStack(spacing: 14) {
                            header
                            amountPanel
                            keypad
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 8)
                        .padding(.bottom, max(proxy.safeAreaInsets.bottom, 8))
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    } else {
                        detailsStep(bottomInset: max(proxy.safeAreaInsets.bottom, 12))
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline.bold())
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: Circle())
            .accessibilityLabel("Close")

            Spacer()

            Text(kind.rawValue)
                .font(.headline.bold())

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 4)
    }

    private var amountPanel: some View {
        VStack(spacing: 14) {
            AmountCarousel(amount: amount)
                .frame(maxWidth: .infinity)
                .frame(height: 184)

            AmountSlider(
                value: Binding(
                    get: { min(amount, 1000) },
                    set: { rawAmount = String(Int($0.rounded())) }
                )
            )
            .frame(height: 70)

            Button {
                guard amount > 0 else { return }
                withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) {
                    step = .details
                }
            } label: {
                Label("Continue", systemImage: "arrow.right")
                    .font(.headline.bold())
                    .labelStyle(.titleAndIcon)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
            }
            .buttonStyle(.plain)
            .foregroundStyle(amount > 0 ? Color.white : Color.white.opacity(0.35))
            .glassEffect(.regular.interactive(), in: Capsule())
            .disabled(amount <= 0)
        }
        .padding(12)
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.105),
                    Color.white.opacity(0.035)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 0.8)
        }
    }

    private func detailsStep(bottomInset: CGFloat) -> some View {
        VStack(spacing: 18) {
            HStack {
                Button {
                    isTitleFocused = false
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) {
                        step = .amount
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline.bold())
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: Circle())
                .accessibilityLabel("Back to amount")

                Spacer()

                Text(kind == .income ? "New Income" : "New Expense")
                    .font(.headline.bold())

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline.bold())
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: Circle())
                .accessibilityLabel("Close")
            }

            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    TextField("Title", text: $title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)
                        .focused($isTitleFocused)

                    Text(amount, format: .currency(code: "SGD"))
                        .font(.title2.bold())
                        .monospacedDigit()
                }
                .padding(.vertical, 8)

                detailsRow(title: "Category", symbol: "square.grid.2x2.fill") {
                    Menu {
                        ForEach(categories, id: \.self) { option in
                            Button(option) {
                                category = option
                            }
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Text(category)
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(NumoTheme.activity)
                    }
                }

                detailsRow(title: "Date", symbol: "calendar") {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(NumoTheme.activity)
                }
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0.10), Color.white.opacity(0.035)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 30, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 0.8)
            }

            Spacer()

            Button {
                let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !cleanedTitle.isEmpty, amount > 0 else { return }

                onConfirm(
                    NewTransactionDraft(
                        kind: kind,
                        amount: Decimal(amount),
                        title: cleanedTitle,
                        category: category,
                        date: date
                    )
                )
                dismiss()
            } label: {
                Label("Save", systemImage: "checkmark")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .buttonStyle(.plain)
            .foregroundStyle(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .white.opacity(0.35) : .white)
            .glassEffect(
                .regular
                    .tint(NumoTheme.activity.opacity(0.50))
                    .interactive(),
                in: Capsule()
            )
            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, bottomInset)
    }

    private func detailsRow<Content: View>(
        title: String,
        symbol: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack {
            Label(title, systemImage: symbol)
                .font(.subheadline.bold())
                .foregroundStyle(NumoTheme.secondaryText)

            Spacer()

            content()
        }
        .frame(height: 44)
        .padding(.horizontal, 14)
        .background(Color.black.opacity(0.20), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var categories: [String] {
        if kind == .income {
            ["Salary", "Freelance", "Gift", "Refund", "Other"]
        } else {
            ["Food", "Shopping", "Housing", "Subscriptions", "Transport", "Other"]
        }
    }

    private var keypad: some View {
        let keys: [KeypadKey] = [
            .digit("1"), .digit("2"), .digit("3"),
            .digit("4"), .digit("5"), .digit("6"),
            .digit("7"), .digit("8"), .digit("9"),
            .decimal, .digit("0"), .delete
        ]

        return LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
            spacing: 8
        ) {
            ForEach(keys) { key in
                Button {
                    handleKey(key)
                } label: {
                    Group {
                        switch key {
                        case .digit(let digit):
                            Text(digit)
                                .font(.system(size: 29, weight: .medium))
                        case .decimal:
                            Text(".")
                                .font(.system(size: 29, weight: .medium))
                        case .delete:
                            Image(systemName: "delete.left.fill")
                                .font(.title3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .contentShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                }
                .buttonStyle(KeypadButtonStyle())
                .accessibilityLabel(key.accessibilityLabel)
            }
        }
    }

    private func handleKey(_ key: KeypadKey) {
        switch key {
        case .digit(let digit):
            let wholeDigits = rawAmount.split(separator: ".", omittingEmptySubsequences: false)[0]
            guard wholeDigits.count < 7 else { return }

            if rawAmount == "0" {
                rawAmount = digit
            } else if let decimalIndex = rawAmount.firstIndex(of: "."),
                      rawAmount.distance(from: decimalIndex, to: rawAmount.endIndex) > 2 {
                return
            } else {
                rawAmount.append(digit)
            }

        case .decimal:
            if !rawAmount.contains(".") {
                rawAmount.append(".")
            }

        case .delete:
            if rawAmount.count > 1 {
                rawAmount.removeLast()
            } else {
                rawAmount = "0"
            }
        }
    }
}

private enum EntryStep {
    case amount
    case details
}

private enum KeypadKey: Identifiable {
    case digit(String)
    case decimal
    case delete

    var id: String {
        switch self {
        case .digit(let digit): "digit-\(digit)"
        case .decimal: "decimal"
        case .delete: "delete"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .digit(let digit): digit
        case .decimal: "Decimal point"
        case .delete: "Delete"
        }
    }
}

private struct KeypadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                Color.white.opacity(configuration.isPressed ? 0.11 : 0.045),
                in: RoundedRectangle(cornerRadius: 17, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .stroke(Color.white.opacity(configuration.isPressed ? 0.22 : 0.12), lineWidth: 0.8)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct AmountCarousel: View {
    let amount: Double

    var body: some View {
        VStack(spacing: 0) {
            Text(formatted(amount + step))
                .font(.system(size: 46, weight: .bold))
                .foregroundStyle(Color.white.opacity(0.035))
                .frame(height: 48)

            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Text("$")
                    .font(.title2.bold())
                    .foregroundStyle(Color.white.opacity(0.52))

                Text(formatted(amount))
                    .font(.system(size: 60, weight: .bold))
                    .minimumScaleFactor(0.62)
                    .lineLimit(1)
                    .contentTransition(.numericText())
            }
            .frame(maxWidth: .infinity)
            .frame(height: 76)

            Text(formatted(max(0, amount - step)))
                .font(.system(size: 46, weight: .bold))
                .foregroundStyle(Color.white.opacity(0.035))
                .frame(height: 48)
        }
        .clipped()
        .animation(.smooth(duration: 0.18), value: amount)
    }

    private var step: Double {
        amount < 100 ? 25 : 250
    }

    private func formatted(_ value: Double) -> String {
        value.formatted(.number.grouping(.automatic).precision(.fractionLength(value.rounded() == value ? 0 : 2)))
    }
}

private struct AmountSlider: View {
    @Binding var value: Double

    var body: some View {
        GeometryReader { proxy in
            let trackWidth = max(proxy.size.width, 1)
            let fraction = min(max(value / 1000, 0), 1)
            let fillWidth = max(78, trackWidth * fraction)

            ZStack(alignment: .leading) {
                tickMarks
                    .padding(.horizontal, 10)

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.black.opacity(0.26))
                    .frame(width: fillWidth)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [NumoTheme.mint.opacity(0.18), Color.black.opacity(0.05)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(NumoTheme.mint.opacity(0.88), lineWidth: 1)
                            .shadow(color: NumoTheme.mint.opacity(0.42), radius: 8)
                    }

                Text("\(Int((fraction * 100).rounded()))%")
                    .font(.headline.bold())
                    .foregroundStyle(NumoTheme.mint)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.38), in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                    .padding(.leading, 8)

                Capsule()
                    .fill(.white)
                    .frame(width: 6, height: 38)
                    .shadow(color: .black.opacity(0.45), radius: 5)
                    .offset(x: min(max(fillWidth - 3, 3), trackWidth - 6))
            }
            .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let fraction = min(max(gesture.location.x / trackWidth, 0), 1)
                        value = (fraction * 1000).rounded()
                    }
            )
            .accessibilityElement()
            .accessibilityLabel("Amount")
            .accessibilityValue("\(Int(value)) dollars")
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: value = min(value + 10, 1000)
                case .decrement: value = max(value - 10, 0)
                @unknown default: break
                }
            }
        }
        .frame(height: 64)
    }

    private var tickMarks: some View {
        HStack(spacing: 6) {
            ForEach(0..<24, id: \.self) { _ in
                Capsule()
                    .fill(Color.white.opacity(0.035))
                    .frame(width: 6, height: 42)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
